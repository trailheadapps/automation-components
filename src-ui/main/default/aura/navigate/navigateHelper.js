({
    getObjectPageReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        var destinationAction = this.require(
            component,
            'destinationAction'
        ).toLowerCase();
        var destinationActionFilter = component.get(
            'v.destinationActionFilter'
        );
        if (!['home', 'list', 'new'].includes(destinationAction)) {
            throw new Error(
                'Invalid Destination Action: ' +
                    destinationAction +
                    '+. Supported values: home, list, new'
            );
        }
        // Return page reference
        return {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: destinationName,
                actionName: destinationAction
            },
            state: {
                filterName: destinationActionFilter
            }
        };
    },

    getRecordPageReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        var destinationAction = this.require(
            component,
            'destinationAction'
        ).toLowerCase();
        var destinationRecordId = this.require(
            component,
            'destinationRecordId'
        );
        if (!['clone', 'edit', 'view'].includes(destinationAction)) {
            throw new Error(
                'Invalid Destination Action: ' +
                    destinationAction +
                    '. Supported values: clone, edit, view'
            );
        }
        // Return page reference
        return {
            type: 'standard__recordPage',
            attributes: {
                recordId: destinationRecordId,
                objectApiName: destinationName,
                actionName: destinationAction
            }
        };
    },

    getAppReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        // Return page reference
        return {
            type: 'standard__app',
            attributes: {
                appTarget: destinationName
            }
        };
    },

    getUrlReference: function (component) {
        // Validate inputs
        var destinationUrl = this.require(component, 'destinationUrl');
        // Return page reference
        return {
            type: 'standard__webPage',
            attributes: {
                url: destinationUrl
            }
        };
    },

    getNamedPageReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        // Return page reference
        return {
            type: 'standard__namedPage',
            attributes: {
                pageName: destinationName
            }
        };
    },

    getTabReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        // Return page reference
        return {
            type: 'standard__navItemPage',
            attributes: {
                apiName: destinationName
            }
        };
    },

    getKnowledgeArticleReference: function (component) {
        // Validate inputs
        var destinationName = this.require(component, 'destinationName');
        var destinationUrl = this.require(component, 'destinationUrl');
        // Return page reference
        return {
            type: 'standard__knowledgeArticlePage',
            attributes: {
                articleType: destinationName,
                urlName: destinationUrl
            }
        };
    },

    getRelatedListReference: function (component) {
        // Validate inputs
        var destinationRecordId = this.require(
            component,
            'destinationRecordId'
        );
        var destinationName = this.require(component, 'destinationName');
        var relationshipName = this.require(component, 'relationshipName');
        // Return page reference
        return {
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: destinationRecordId,
                objectApiName: destinationName,
                actionName: 'view',
                relationshipApiName: relationshipName
            }
        };
    },

    require: function (component, attributeName) {
        var value = component.get('v.' + attributeName);
        if (!value) {
            throw new Error(
                'Missing mandatory value for attribute ' + attributeName
            );
        }
        return value;
    }
});
