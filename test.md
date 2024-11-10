# Nginx and Keycloak: A Perfect Pair for Gateway Security
## Sergey Dudik
Oct 23, 2023

In today’s fast-paced digital landscape, ensuring robust security at every point of user interaction is paramount. While there are numerous tools available to fortify our applications, finding the perfect synergy between them can be a challenge. Enter the dynamic duo: Nginx and Keycloak. When paired together, these powerful technologies provide an unparalleled security solution for your gateway. Nginx, known for its high-performance and scalability, combined with the robust authentication and authorization mechanisms of Keycloak, creates a fortress, safeguarding your applications from unauthorized access. In this article, we’ll explore the ins and outs of this compelling combination, demonstrating how you can harness their collective strengths to build a fortified, yet user-friendly, gateway for your applications.

Before diving into Nginx and Keycloak, let’s revisit some foundational concepts of security.

## Understanding the Difference: Authentication vs. Authorization
In the realm of security, the terms “authentication” and “authorization” often come up. Although they might sound similar and are sometimes used interchangeably, they have distinct meanings and functions. Let’s delve into each of these terms to understand their differences and importance.

## 1. Authentication
Definition: Authentication refers to the process of verifying the identity of a user, system, or application. It answers the question, “Are you who you say you are?”

How it Works: The most common form of authentication is a username and password combination. When a user enters these credentials, the system compares them against stored data to verify their identity. Other methods include biometrics (like fingerprint or facial recognition), OTPs (one-time passwords), and hardware tokens.

Examples:

Entering a password to log into your email account.
Using a fingerprint to unlock your smartphone.
Receiving an SMS code to confirm your identity on a banking website.

## 2. Authorization
Definition: Once authentication is established, authorization determines what that user, system, or application is permitted to do. It answers the question, “Do you have permission to perform this action?”

How it Works: Authorization is typically managed by setting permissions or roles. For instance, a user might be granted read-only access to a database, while an admin has the rights to both read and modify it.

Examples:

A standard employee might access a company portal but can’t make changes to certain critical documents. An administrator, on the other hand, can modify, delete, or even share those documents.

In a file-sharing app, you might grant some users the ability to view a file, while others can edit it.

While both authentication and authorization play critical roles in security, they serve distinct purposes:

Authentication ensures you are communicating with the right entity by validating their identity.

Authorization ensures that entity has the correct permissions to perform certain actions.

## What is Gateway?
Also known as API Gateway is a service that acts as an intermediary for requests from clients seeking resources from other servers or services. Many organizations use API Gateways in microservice architectures to manage and secure the complex interactions between microservices. Popular API Gateways include Amazon API Gateway, Kong, Apigee, and WSO2.

There is a great article if you want to know more about API Gateway and its usage:

https://medium.com/buildpiper/how-do-api-gateways-work-3b989fdcd751

## How can you secure your backend?
Imagine we are developing a web application comprised of three components:

Single-page application (SPA) built with frameworks like React or Angular
Data Service that handles all CRUD operations related to our domain entities and manages the connection to the database
Report Service that fetches data from the Data Service and encapsulates the logic for generating custom reports

Typical architecture
When it comes to securing the backend, there are three primary strategies to consider:

Each microservice handles its own authentication and authorization.
The gateway manages authentication while individual services are responsible for authorization.
The gateway takes care of both authentication and authorization.
Each approach has its unique strengths and limitations. For the sake of brevity, this article won’t delve into which strategy is superior. Truthfully, determining the best fit requires a comprehensive understanding of the system in question.

In the following sections, we will explore the second and third strategies in-depth, focusing on how NGINX and Keycloak can be effectively employed for these purposes.

## What is Keycloak?
Keycloak is an open-source Identity and Access Management (IAM) tool developed by Red Hat. It provides advanced features such as Single Sign-On (SSO), Identity Brokering, and Social Login without the need for deep, specialized security expertise.

Keycloak’s blend of flexibility, comprehensive features, and active community support has solidified its reputation in the identity and access management space. As organizations continue to seek efficient ways to manage identities without compromising security, tools like Keycloak remain indispensable.

## What is Nginx?
Nginx was created by Igor Sysoev in 2002, with its first public release in 2004. Originally developed to address the C10K problem (handling 10,000 simultaneous connections), Nginx was built from the ground up to be highly efficient and scalable.

At its core, Nginx is a web server. But over the years, it has evolved into so much more. Today, Nginx can also function as a reverse proxy server, load balancer, mail proxy server, and even an HTTP cache.

## Nginx Plus issue
Nginx offers a free version of its software, but there’s also a premium paid version known as Nginx Plus. While Nginx Plus supports Single Sign-On with Keycloak, the free version unfortunately does not. It’s a bit disappointing, given the popularity of both Nginx and Keycloak. At TargPatrol, we utilize both tools, so we’ve had to devise a method for them to effectively communicate with each other.

## Modernized architecture
Let’s make some adjustments to our architecture. The updated version is depicted in the image below.


Modernized architecture
As illustrated, the Nginx service now functions as an API Gateway. Its primary role is to handle both authentication and authorization. Meanwhile, the Keycloak service acts as our Single Sign-On (SSO) server. The Data Service and Report Service process requests coming from Nginx, but they no longer manage authentication or authorization for these requests.

I won’t delve into the integration of SPA with Keycloak in this article, as there are numerous comprehensive resources available on this topic. For instance, you can refer to this well-written guide: https://medium.hexadefence.com/securing-a-react-app-using-keycloak-ac0ee5dd4bfc.

How should we handle authentication in this scenario? We can use nginx authentication proxy.

Now, let’s examine the nginx configuration:

```Nginx
http {

  ...

  location /auth {
     proxy_ssl_server_name on;
     proxy_pass  https://targpatrol-keycloak.local/realms/targpatrol-dev/protocol/openid-connect/userinfo;
     proxy_pass_request_body off;
     proxy_set_header Content-Length "";
     proxy_set_header X-Original-URI $request_uri;
  }

  location /data {
     auth_request /auth;
     auth_request_set $auth_status $upstream_status;
     error_page 401 = @handle_unauthorized;

     proxy_pass http://data-service.local;
     include /etc/nginx/common/ssl-headers.conf;

     js_content authService.authorize;
  }

  location /report {
     auth_request /auth;
     auth_request_set $auth_status $upstream_status;
     error_page 401 = @handle_unauthorized;

     proxy_pass http://report-service.local;
     include /etc/nginx/common/ssl-headers.conf;

     js_content authService.authorize;
  }
}
```

What’s happening here? First, we’ve defined the /auth route that validates our request using Keycloak. We simply send the request with headers only to Keycloak, requesting user information. If we possess a valid token in our header, Keycloak will respond with a 200 OK, returning the current user’s data.

The routes for the Data and Report services contain the ‘auth_request’ instruction. Every time we attempt to access them, a request will be sent to Keycloak first.

Alright, we understand the authentication process, but what about authorization? For this, we can leverage a functionality in nginx called ngx_http_js_module. This module permits the execution of JavaScript code on a request. Let’s delve into the ‘js_content’:
```Javascript
function extractPayload (token) {
   const tokenParts = token.split('.');
   const encodedPayload = tokenParts[1];
   const decodedPayload = Buffer.from(encodedPayload, 'base64').toString('utf-8');

   return JSON.parse(decodedPayload);
}


function authorize(request) {
   const token = request.headersIn.Authorization;

   if (!token || !(token.slice(0, 7) === 'Bearer ')) {
       return false;
   }

   const payload = extractPayload(token);
   const roles = payload['roles'];

   # request url
   const url = request.uri;


   # here we can compare url and roles
   # to allow or deny access

   return false;
}
```
This file is named authService.js. It should contain a function named authorize since, in our js_content instruction, we reference it as authService.authorize (following the format fileName.functionName). Plain JavaScript can be utilized here. Initially, we parse the Authorization header to extract the Bearer token, which was generated by Keycloak, into an object form. Subsequently, we can match the roles with the request URL to either grant or deny the request. It’s all quite straightforward!

One challenge with this approach is that every request is directed to Keycloak. A possible solution is to transition from nginx’s js_content to a Node.js service (or another suitable language). This service would have server-side integration with Keycloak. It’s worth noting that only Nginx Plus supports this, not the free version. For more details, you can refer to: Keycloak’s documentation.

## Conclusion
In summary, the synergy between Nginx and Keycloak offers a compelling solution for gateway security. While Nginx efficiently manages and routes web traffic, Keycloak ensures robust authentication and authorization. Their combined capabilities create a fortified layer of defense, enhancing both user experience and system security. By seamlessly integrating these tools, businesses can achieve not only heightened protection but also streamlined operations. As the digital landscape continues to evolve, tools like Nginx and Keycloak are proving indispensable for those seeking a balanced combination of performance, flexibility, and security.
