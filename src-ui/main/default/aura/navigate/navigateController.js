({
    invoke: function (component, event, helper) {
        var navService = component.find('navService');

        var destinationType = component.get('v.destinationType').toLowerCase();
        var pageReference;

        switch (destinationType) {
            case 'object':
                pageReference = helper.getObjectPageReference(component);
                break;

            case 'record':
                pageReference = helper.getRecordPageReference(component);
                break;

            case 'app':
                pageReference = helper.getAppReference(component);
                break;

            case 'url':
                pageReference = helper.getUrlReference(component);
                break;

            case 'namedpage':
                pageReference = helper.getNamedPageReference(component);
                break;

            case 'tab':
                pageReference = helper.getTabReference(component);
                break;

            case 'knowledge':
                pageReference = helper.getKnowledgeArticleReference(component);
                break;

            case 'relatedlist':
                pageReference = helper.getRelatedListReference(component);
                break;

            default:
                throw new Error(
                    'Invalid destination type value: "' +
                        destinationType +
                        '". Supported values: object, record, app, url, tab, knowledge, namedpage, relatedlist'
                );
        }
        navService.navigate(pageReference);
    }
});
