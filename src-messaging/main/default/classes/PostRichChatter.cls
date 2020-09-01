global class PostRichChatter {
    private final static Pattern SPAN = Pattern.compile('<\\/?span[^>]*>');
    private final static Pattern ANCHOR = Pattern.compile(
        '(<a href="([^"]+)" target="_blank">([^<]+)<\\/a>)'
    );
    private final static Pattern INDENT = Pattern.compile(
        ' class="ql-indent-[1-4]"'
    );
    private final static Pattern IMAGE = Pattern.compile('<img src="([^"]+)">');

    /**
     * Posts a rich text Chatter message
     * Inputs:
     *   String body
     *   String targetNameOrId Reference to the User, Chatter group, or record whose feed you want to post to.
     *   Id communityId Optional Community Id if posting to a Community
     * Outputs:
     *   Id feedItemId
     */
    @InvocableMethod(
        label='Posts a rich text Chatter message'
        category='Messaging'
    )
    global static List<OutputParameters> bulkInvoke(
        List<InputParameters> inputs
    ) {
        List<OutputParameters> outputs = new List<OutputParameters>();
        for (InputParameters input : inputs) {
            outputs.add(invoke(input));
        }
        return outputs;
    }

    private static OutputParameters invoke(InputParameters input) {
        // Get inputs
        String body = input.body;
        Id targetId;
        try {
            // Use targetNameOrId as an Id
            targetId = Id.valueOf(input.targetNameOrId);
        } catch (System.StringException e) {
            // targetNameOrId is not an Id, try to use it as a group name or username
            targetId = getGroupOrUserFromName(input.targetNameOrId);
        }
        Id communityId = input.communityId;

        // Build and post Chatter message
        body = convertFlowRichText(body);
        ConnectApi.FeedElement feedElement = ConnectApiHelper.postFeedItemWithRichText(
            communityId,
            targetId,
            body
        );

        // Return output
        OutputParameters output = new OutputParameters();
        output.feedItemId = feedElement.id;
        return output;
    }

    /**
     * Reformats Flow rich text into Chatter rich text
     */
    private static String convertFlowRichText(String originalBody) {
        //several things that Flow rich text supports, like color and font size, are represented by span tags. chatter doesn't support, so need to strip them out
        Matcher matcher = SPAN.matcher(originalBody);
        String body = matcher.replaceAll('');

        // Chatter's support for hyperlinks is unconventional and I haven't figured out how to convert a normal anchor link (<a href="http://www.salesforce.com" target="_blank">link</a>) into the chatter equivalent
        // so this hack puts the url into a parentheses next to the link word. anyone who has a better approach is encouraged.
        // extract the url find all strings that start with <a and end with > i.e.extract url from an anchor tag
        // extract the text craft a replacement string
        // matcher = ANCHOR.matcher(body);
        // body = matcher.replaceAll('$3 ($2) ');
        // also have to strip out indent markup:
        // Here's some indented stuff:</p><p class="ql-indent-2">I'm indented</p><p>
        matcher = INDENT.matcher(body);
        body = matcher.replaceAll('');

        //image links work fine, but we'll do a little reformatting to remove the html
        matcher = IMAGE.matcher(body);
        body = matcher.replaceAll('image: $1');

        return body;
    }

    /**
     * Get an Id from a group name or username
     */
    private static Id getGroupOrUserFromName(String name) {
        List<Group> groups = [SELECT Id FROM Group WHERE Name = :name];
        if (groups.size() > 0) {
            return groups[0].Id;
        }
        List<User> users = [SELECT Id FROM User WHERE Username = :name];
        if (users.size() > 0) {
            return users[0].Id;
        }
        throw new InvalidNameException(
            'Couldn\'t find a group name or username matching ' + name
        );
    }

    global class InvalidNameException extends Exception {
    }

    /**
     * Wrapper class for input parameters
     */
    global class InputParameters {
        @InvocableVariable(required=true)
        global String body;
        @InvocableVariable(
            required=true
            description='Reference to the user, Chatter group, or record whose feed you want to post to.'
        )
        global String targetNameOrId;
        @InvocableVariable(
            required=false
            description='Optional Community Id if posting to a Community'
        )
        public Id communityId;
    }

    /**
     * Wrapper class for output parameters
     */
    global class OutputParameters {
        @InvocableVariable
        global Id feedItemId;
    }
}
