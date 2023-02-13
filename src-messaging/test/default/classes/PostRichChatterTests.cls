@isTest
global class PostRichChatterTests {
    private static final String BODY_INPUT = '&lt;p&gt;Content with a&amp;nbsp;&lt;a href=&quot;https://salesforce.com&quot; target=&quot;_blank&quot;&gt;link&lt;/a&gt;.&lt;/p&gt;&lt;p&gt;&lt;b&gt;Bold content&lt;/b&gt;.&lt;/p&gt;&lt;p&gt;&lt;u&gt;Underlined content&lt;/u&gt;.&lt;/p&gt;&lt;p&gt;&lt;i&gt;Italic content&lt;/i&gt;.&lt;/p&gt;&lt;ul&gt;&lt;li&gt;UL item 1&lt;/li&gt;&lt;li&gt;UL item 2&lt;/li&gt;&lt;/ul&gt;&lt;ol&gt;&lt;li&gt;OL item 1&lt;/li&gt;&lt;li&gt;OL item 2&lt;/li&gt;&lt;/ol&gt;';
    private static final String BODY_OUTPUT = '<p>Content with a <a href="https://salesforce.com" target="_blank">link</a>.</p><p><b>Bold content</b>.</p><p><u>Underlined content</u>.</p><p><i>Italic content</i>.</p><ul><li>UL item 1</li><li>UL item 2</li></ul><ol><li>OL item 1</li><li>OL item 2</li></ol>';

    @isTest(SeeAllData=true)
    global static void bulkInvoke_works_with_user_id() {
        Id userId = UserInfo.getUserId();

        PostRichChatter.InputParameters input = new PostRichChatter.InputParameters();
        input.body = BODY_INPUT;
        input.targetNameOrId = userId;
        List<PostRichChatter.InputParameters> inputs = new List<PostRichChatter.InputParameters>{
            input
        };

        List<PostRichChatter.OutputParameters> outputs = PostRichChatter.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        Id feedItemId = outputs[0].feedItemId;

        FeedItem feedItem = [
            SELECT Body, ParentId
            FROM FeedItem
            WHERE Id = :feedItemId
        ];
        String itemBody = feedItem.Body.unescapeHtml4().replace('&nbsp;', ' ');
        Assert.areEqual(BODY_OUTPUT, itemBody);
        Assert.areEqual(userId, feedItem.ParentId);
    }

    @isTest(SeeAllData=true)
    global static void bulkInvoke_works_with_group_id() {
        CollaborationGroup testGroup = getTestGroup();

        PostRichChatter.InputParameters input = new PostRichChatter.InputParameters();
        input.body = BODY_INPUT;
        input.targetNameOrId = testGroup.Id;
        List<PostRichChatter.InputParameters> inputs = new List<PostRichChatter.InputParameters>{
            input
        };

        List<PostRichChatter.OutputParameters> outputs = PostRichChatter.bulkInvoke(
            inputs
        );

        Assert.areEqual(1, outputs.size());
        Id feedItemId = outputs[0].feedItemId;

        FeedItem feedItem = [
            SELECT Body, ParentId
            FROM FeedItem
            WHERE Id = :feedItemId
        ];
        String itemBody = feedItem.Body.unescapeHtml4().replace('&nbsp;', ' ');
        Assert.areEqual(BODY_OUTPUT, itemBody);
        Assert.areEqual(testGroup.Id, feedItem.ParentId);

        delete testGroup;
    }

    @isTest(SeeAllData=true)
    global static void bulkInvoke_fails_when_invalid_target_name() {
        PostRichChatter.InputParameters input = new PostRichChatter.InputParameters();
        input.body = BODY_INPUT;
        input.targetNameOrId = 'invalid';
        List<PostRichChatter.InputParameters> inputs = new List<PostRichChatter.InputParameters>{
            input
        };

        try {
            PostRichChatter.bulkInvoke(inputs);
            Assert.fail('Expected InvalidNameException');
        } catch (PostRichChatter.InvalidNameException e) {
            Assert.isTrue(e.getMessage().contains('Couldn\'t find'));
        }
    }

    private static CollaborationGroup getTestGroup() {
        // Check if group exists
        List<CollaborationGroup> groups = [
            SELECT Id
            FROM CollaborationGroup
            WHERE Name = 'PostRichChatterTests'
        ];
        if (groups.size() > 0) {
            return groups[0];
        }
        // Create it if needed
        CollaborationGroup testGroup = new CollaborationGroup();
        testGroup.Name = 'Test Group';
        testGroup.CollaborationType = 'Public';
        insert testGroup;
        return testGroup;
    }
}
