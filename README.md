# Automation Components

[![CI Workflow](<https://github.com/trailheadapps/automation-components/workflows/Salesforce%20DX%20(scratch%20org)/badge.svg?branch=master>)](https://github.com/trailheadapps/automation-components/actions?query=workflow%3A%22Salesforce+DX+%28scratch+org%29%22) [![Packaging Workflow](https://github.com/trailheadapps/automation-components/workflows/Packaging/badge.svg?branch=master)](https://github.com/trailheadapps/automation-components/actions?query=workflow%3A%22Packaging%22) [![codecov](https://codecov.io/gh/trailheadapps/automation-components/branch/master/graph/badge.svg)](https://codecov.io/gh/trailheadapps/automation-components)

Automation Components provides a set of reusable and production-ready extensions that include invocable actions, flow screen components and local actions. These are intended as an easy to install, easy to use toolbox. Read more in this [blog post](https://developer.salesforce.com/blogs/2020/05/introducing-automation-components.html).

This is an Open Source project. A special thanks to the project contributors.

Check out the community site [unofficialsf.com](https://unofficialsf.com/) for more Automation developer resources.

## Table of contents

-   📖 **[Automation Components Reference](https://github.com/trailheadapps/automation-components/wiki)**

-   [Installing the components using Managed Packages](#installing-the-components-using-managed-packages): This is the recommended installation option. This option allows anybody to experience the components without installing a local development environment.

-   [Installing the components using a Scratch Org](#installing-the-components-using-a-scratch-org): Use this option if you are a developer who wants to experience the components and the code.

-   [Installing the components using a Developer Edition Org or a Trailhead Playground](#installing-the-components-using-a-developer-edition-org-or-a-trailhead-playground): Useful when tackling Trailhead Badges or if you want the components deployed to a more permanent environment than a Scratch org.

-   [Optional installation instructions](#optional-installation-instructions)

## Installing the components using Managed Packages

Follow this set of instructions if you want to deploy the components to your production org or to a development environment that's more permanent than a Scratch org. You can use a non source-tracked orgs such as a free [Developer Edition Org](https://developer.salesforce.com/signup), a [Trailhead Playground](https://trailhead.salesforce.com/) or a production org.

1. Log in to your org

1. If you are setting up a Developer Edition: go to **Setup**, under **My Domain**, [register a My Domain](https://help.salesforce.com/articleView?id=domain_name_setup.htm&type=5).

1. Click links from the table to install the managed packages in your org.

    Disclaimer: these packages haven't gone through security review yet but that is our plan for the future.

| Package Name           | Install Link                                                                                                                               | Documentation Link                                                                                  |
| ---------------------- | ------------------------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------------- |
| Apex Formula Evaluator | <a name="AC - Apex Formula Evaluator" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005qrweAAA">Install</a> | [Documentation](https://github.com/trailheadapps/automation-components/wiki/apex-formula-evaluator) |
| Collections            | <a name="AC - Collections" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ufmuAAA">Install</a>            | [Documentation](https://github.com/trailheadapps/automation-components/wiki/collections)            |
| Data                   | <a name="AC - Data" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ueb6AAA">Install</a>                   | [Documentation](https://github.com/trailheadapps/automation-components/wiki/data)                   |
| Flows                  | <a name="AC - Flows" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ufn4AAA">Install</a>                  | [Documentation](https://github.com/trailheadapps/automation-components/wiki/flows)                  |
| Messaging              | <a name="AC - Messaging" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005uebGAAQ">Install</a>              | [Documentation](https://github.com/trailheadapps/automation-components/wiki/messaging)              |
| Security               | <a name="AC - Security" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ufmpAAA">Install</a>               | [Documentation](https://github.com/trailheadapps/automation-components/wiki/security)               |
| Strings                | <a name="AC - Strings" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ufn9AAA">Install</a>                | [Documentation](https://github.com/trailheadapps/automation-components/wiki/strings)                |
| UI                     | <a name="AC - UI" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005ufmzAAA">Install</a>                     | [Documentation](https://github.com/trailheadapps/automation-components/wiki/ui)                     |
| Utilities              | <a name="AC - Utilities" href="https://login.salesforce.com/packaging/installPackage.apexp?p0=04t5w000005qrwoAAA">Install</a>              | [Documentation](https://github.com/trailheadapps/automation-components/wiki/utilities)              |

## Installing the components using a Scratch Org

1. Set up your environment. Follow the steps in the [Quick Start: Lightning Web Components](https://trailhead.salesforce.com/content/learn/projects/quick-start-lightning-web-components/) Trailhead project. The steps include:

    - Enable Dev Hub in your Trailhead Playground
    - Install Salesforce CLI
    - Install Visual Studio Code
    - Install the Visual Studio Code Salesforce extensions, including the Lightning Web Components extension

1. If you haven't already done so, authorize your hub org and provide it with an alias (**myhuborg** in the command below):

    ```
    sfdx force:auth:web:login -d -a myhuborg
    ```

1. Clone this repository:

    ```
    git clone https://github.com/trailheadapps/automation-components
    cd automation-components
    ```

1. Create a scratch org and provide it with an alias (**automation** in the command below):

    ```
    sfdx force:org:create -s -f config/project-scratch-def.json -a automation
    ```

1. Push the app to your scratch org:

    ```
    sfdx force:source:push
    ```

1. Open the scratch org:

    ```
    sfdx force:org:open
    ```

## Installing the components using a Developer Edition Org or a Trailhead Playground

Follow this set of instructions if you want to deploy the app to a more permanent environment than a Scratch org.
This includes non source-tracked orgs such as a [free Developer Edition Org](https://developer.salesforce.com/signup) or a [Trailhead Playground](https://trailhead.salesforce.com/).

1. Clone this repository:

    ```
    git clone https://github.com/trailheadapps/automation-components
    cd automation-components
    ```

1. Authorize your Trailhead Playground or Developer org and provide it with an alias (**mydevorg** in the command below):

    ```
    sfdx force:auth:web:login -s -a mydevorg
    ```

1. If you are setting up a Developer Edition: go to **Setup**, under **My Domain**, [register a My Domain](https://help.salesforce.com/articleView?id=domain_name_setup.htm&type=5).

1. Run this command in a terminal to deploy the app.

    ```
    sfdx force:source:deploy -p src-collections,src-data,src-flows,src-messaging,src-security,src-strings,src-ui,src-utilities
    ```

1. If your org isn't already open, open it now:

    ```
    sfdx force:org:open -u mydevorg
    ```

## Optional Installation Instructions

This repository contains several files that are relevant if you want to integrate modern web development tooling to your Salesforce development processes, or to your continuous integration/continuous deployment processes.

### Code formatting

[Prettier](https://prettier.io/) is a code formatter used to ensure consistent formatting across your code base. To use Prettier with Visual Studio Code, install [this extension](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode) from the Visual Studio Code Marketplace. The [.prettierignore](/.prettierignore) and [.prettierrc](/.prettierrc) files are provided as part of this repository to control the behavior of the Prettier formatter.

### Code linting

[ESLint](https://eslint.org/) is a popular JavaScript linting tool used to identify stylistic errors and erroneous constructs. To use ESLint with Visual Studio Code, install [this extension](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode-lwc) from the Visual Studio Code Marketplace. The [.eslintignore](/.eslintignore) file is provided as part of this repository to exclude specific files from the linting process in the context of Lightning Web Components development.

### Pre-commit hook

This repository also comes with a [package.json](./package.json) file that makes it easy to set up a pre-commit hook that enforces code formatting and linting by running Prettier and ESLint every time you `git commit` changes.

To set up the formatting and linting pre-commit hook:

1. Install [Node.js](https://nodejs.org) if you haven't already done so
1. Run `npm install` in your project's root folder to install the ESLint and Prettier modules (Note: Mac users should verify that Xcode command line tools are installed before running this command.)

Prettier and ESLint will now run automatically every time you commit changes. The commit will fail if linting errors are detected. You can also run the formatting and linting from the command line using the following commands (check out [package.json](./package.json) for the full list):

```
npm run lint:lwc
npm run prettier
```
