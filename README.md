# Example of a self-signed certificate
In this repository, I suggest looking at options for working with self-signed certificates. 
If you find any errors or want to suggest an improvement, please, [make an issue](https://github.com/mrt1m/self-signed-certificate/issues) in a current repository

## Requirements

- Docker version 25.0.5

## Quick guide

0) Copy env and build openssl image
    ```sh
    cp .env.example .env
    make openssl-build-image
    ```
   
1) Create root certificate chain, server certificate, user certificates and configuration for nginx
    ```sh
    make step-create_all_certs-and-nginx_configs step-run_nginx
    ```
   ![screenshot of the result of creating a certificate chain](./docs/img/step-1.png)

2) Run tests to check HTTPS and connections with the client certificate
    ```sh
    make step-run_tests
    ```
   ![screenshot of the result of tests](./docs/img/step-2.png)

3) Check links in browser
-  https://localhost/
-  https://localhost/protection-magic/  
   ![screenshot of the result of check links in browser](./docs/img/step-3.png)

4) Import intermediate CA
    <details>
      <summary>macOS</summary>
    
      ```sh
      make import-macos-ca CA_NAME=intermediate.level_2.root.ca
      ```
    </details>

5) Check links in browser
-  https://localhost/  
   ![screenshot of the result of check index page in browser](./docs/img/step-5_1.png)
-  https://localhost/protection-magic/  
   ![screenshot of the result of check protection page in browser](./docs/img/step-5_2.png)

6) Import client certificates

    <details>
      <summary>macOS</summary>
    
      ```sh
      make import-macos-client CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_1@lol.kek
      make import-macos-client CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_2@lol.kek
      ```
    </details>

7) Re-enter the OS profile so that the system selects user certificates

8) Run nginx
    ```sh
    make step-run_nginx
    ```

9) Check links in browser incognito mode

> [!IMPORTANT]
> Remember, if you want to change the user certificate, you need to restart the browser

![screenshot of selecting a user certificate](./docs/img/step-9.png)

- Don't select a user
  -  https://localhost/  
     ![screenshot of the result of check index page in browser](./docs/img/step-5_1.png)
  -  https://localhost/protection-magic/  
     ![screenshot of the result of check protection page in browser](./docs/img/step-5_2.png)
- Select user_1 - this user's certificate has been revoked, so any page will return a 400 Bad Request
   -  https://localhost/
   -  https://localhost/protection-magic/  
      ![screenshot of the result in browser](./docs/img/step-9_1.png)
- Select user_2 - this user's certificate is active
   -  https://localhost/  
      ![screenshot of the result of check index page in browser](./docs/img/step-5_1.png)
   -  https://localhost/protection-magic/  
      ![screenshot of the result of check protection page in browser](./docs/img/step-9_2.png)

10) Now in the OS settings we will see the following certificates
    <details>
      <summary>macOS</summary>

      1) open keychain  
         ![screenshot of keychain icon](./docs/img/step-10_1.png)
      2) certificates  
         ![screenshot of certificates](./docs/img/step-10_2.png)
         ![screenshot of ca certificate](./docs/img/step-10_3.png)
         ![screenshot of clients certificates](./docs/img/step-10_4.png)
      3) keychains  
         ![screenshot of keychains](./docs/img/step-10_5.png)
   </details>

---

## Task lists

- [ ] Add import commands for Windows and Linux
- [ ] Add documentation
- [ ] Add openssl OCSP example
