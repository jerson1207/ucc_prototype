# UCC Prototype
### Prerequisites
- [ ] You have installed [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
- [ ] You have installed [Ruby](https://www.ruby-lang.org/en/documentation/installation/).
- [ ] You have installed [Rails](https://guides.rubyonrails.org/getting_started.html#installing-rails).
- [ ] You have installed [Bundler](https://bundler.io/).
- [ ] You have installed [Yarn](https://yarnpkg.com/getting-started/install).

## Cloning the Repository
To clone the repository, follow these steps:

1. Open your terminal.

2. Navigate to the directory where you want to clone the project, for example:
    ```bash
    cd path/to/your/directory
    ```

3. Clone the repository using the following command:
    ```bash
    git clone https://github.com/jerson1207/ucc_prototype.git
    ```

## Navigating to the Project Directory
After cloning the repository, navigate into the project directory:
```bash
cd ucc_prototype
```

```bash
bundle install
```
To run the project locally, use the following command:
```bash
 bin/dev
```
Accessing the Project
http://localhost:3000

### Run the following commands if still not working
```bash
./bin/rails javascript:install:esbuild
./bin/bundle add jsbundling-rails
bundle add jsbundling-rails
bundle add cssbundling-rails
yarn add @hotwired/turbo-rails
yarn add @hotwired/stimulus
yarn add chart.js
yarn add chart.js chartjs-plugin-datalabels
```
