## [1.1.0](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.5...v1.1.0) (2022-02-23)


### Features

* **cosign:** use sigstore to verify the hashdir cli ([143cba7](https://github.com/brad-jones/asdf-bootstrap/commit/143cba7e63527cf7e23196452bde0485a4f7e582))
* **utils:** differentiate tools this script uses from ones it installs ([f153c13](https://github.com/brad-jones/asdf-bootstrap/commit/f153c13b01a9741da3532f7e7c33123107de7675))


### Bug Fixes

* **cosign:** dont override cosign version env var ([4ba14b8](https://github.com/brad-jones/asdf-bootstrap/commit/4ba14b828ebdaff627ae89433c3c84536cbcc517))


### Automation

* bust the asdf cache and add the utils dir ([14489f5](https://github.com/brad-jones/asdf-bootstrap/commit/14489f5b8f74e9a9ca2b090bf563b03927aba863))
* disable asdf cache ([6c77fe2](https://github.com/brad-jones/asdf-bootstrap/commit/6c77fe2267cfa4e925606077a3c8f1ce0b9153a6))
* thats right there are 3 locations for asdf cache ([ed83252](https://github.com/brad-jones/asdf-bootstrap/commit/ed83252529914c17323cd0bcf8c170c4dba2f423))

### [1.0.5](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.4...v1.0.5) (2022-02-22)


### Misc

* **cosign:** just some notes about the sigstore so I don't forget ([8269302](https://github.com/brad-jones/asdf-bootstrap/commit/8269302d1de97bc7f45dd0ee21207b4b01b56dcd))

### [1.0.4](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.3...v1.0.4) (2022-02-22)


### Automation

* **cosign:** enable OIDC with id-token permission ([22389e2](https://github.com/brad-jones/asdf-bootstrap/commit/22389e2be4277ae594da4383e5d102e8244017a0))
* **cosign:** need to make COSIGN_EXPERIMENTAL and env var ([0b87fff](https://github.com/brad-jones/asdf-bootstrap/commit/0b87fffbe595362c8025fc4977e9f44804e17971))
* **cosign:** set the oidc-issuer to github's token.actions endpoint ([7dbadb8](https://github.com/brad-jones/asdf-bootstrap/commit/7dbadb89871da9587cac90e09d01e5268e9d83f9))
* **cosign:** sign our releases with sigstore ([e6783d6](https://github.com/brad-jones/asdf-bootstrap/commit/e6783d6e23b3ef386e0ab52273bb841d8faafe08))

### [1.0.3](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.2...v1.0.3) (2022-02-10)


### Automation

* **cas:** fix cas login, api-key flag didn't appear to work ([c954e97](https://github.com/brad-jones/asdf-bootstrap/commit/c954e971154091a41483392b67f74db4d078a76c))

### [1.0.2](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.1...v1.0.2) (2022-02-10)


### Automation

* **cas:** fix verification of the cas tool it's self ([373a630](https://github.com/brad-jones/asdf-bootstrap/commit/373a630f0343a03f1ed04968971185fe57404755))

### [1.0.1](https://github.com/brad-jones/asdf-bootstrap/compare/v1.0.0...v1.0.1) (2022-02-10)


### Automation

* **cas:** notiarize our release using code notary ([d4d3a4f](https://github.com/brad-jones/asdf-bootstrap/commit/d4d3a4f4374b1005bf8b4f624555ac2af63ecbd0))

## 1.0.0 (2022-02-09)


### Features

* initial commit ([e7138d8](https://github.com/brad-jones/asdf-bootstrap/commit/e7138d8919add5ff122313141e0ce9fa15f05148))
