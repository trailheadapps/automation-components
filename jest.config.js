const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');
module.exports = {
    ...jestConfig,
    moduleNameMapper: {
        '^lightning/flowSupport$': '<rootDir>/jest-mocks/lightning/flowSupport'
    },
    setupFilesAfterEnv: ['<rootDir>/jest-sa11y-setup.js']
};
