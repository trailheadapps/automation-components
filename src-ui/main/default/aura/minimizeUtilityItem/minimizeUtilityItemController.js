({
    invoke: function (component) {
        var utilityAPI = component.find('utilityBar');

        // Minimize utility bar if it's open
        utilityAPI
            .getUtilityInfo()
            .then(function (response) {
                if (response.utilityVisible) {
                    utilityAPI.minimizeUtility();
                }
            })
            .catch(function (error) {
                // eslint-disable-next-line no-console
                console.error(error);
            });
    }
});
