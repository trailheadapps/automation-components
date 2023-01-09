/*
Copyright (c) 2018, salesforce.com, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of the salesforce.com, Inc. nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
OF THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 *
 * Unit tests for ConnectApiHelper.
 *
 * This class works with API version 43.0 and later. There are separate classes
 * that work with v42.0 and earlier.
 *
 * See https://github.com/forcedotcom/ConnectApiHelper for more information.
 *
 */

@IsTest(SeeAllData=true)
public class ConnectApiHelperTest {

    @IsTest(SeeAllData=true)
    static void testInvalidMentionType() {
        try {
            ConnectApiHelper.postFeedItemWithMentions(null, 'me', '{001x00000000D7m}'); // not a group or user id
            Assert.fail('Expected ConnectApiException');
        }
        catch (ConnectApi.ConnectApiException e) {
            Assert.areEqual('Only user and group IDs may be used in inline mentions.', e.getMessage());
        }
    }

    @IsTest(SeeAllData=true)
    static void testNullString() {
        try {
            List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(null);
            Assert.fail('Expected InvalidParameterException');
        }
        catch (ConnectApiHelper.InvalidParameterException e) {
            Assert.isTrue(true);
        }
    }

    @IsTest(SeeAllData=true)
    static void testEmptyString() {
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs('');
        Assert.areEqual(0, segments.size());
    }

    @IsTest(SeeAllData=true)
    static void testNoMentions() {
        String text = 'hey there';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.TextSegmentInput.class);
        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        Assert.areEqual(text, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testMentionOnly() {
        String mentionId = '005x0000000URNP';
        String text = '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MentionSegmentInput.class);
        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        Assert.areEqual(mentionId, mentionSegment.id);
    }

    @IsTest(SeeAllData=true)
    static void testLeadingMention() {
        String mentionId = '005x0000000URNPzzz';
        String restOfMessage = ' - how are you?';
        String text = '{' + mentionId + '}' + restOfMessage;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(2, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MentionSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.TextSegmentInput.class);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        Assert.areEqual(mentionId, mentionSegment.id);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        Assert.areEqual(restOfMessage, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testTrailingMention() {
        String restOfMessage = 'Here we go: ';
        String mentionId = '005x0000000URNPzzz';
        String text = restOfMessage + '{' + mentionId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(2, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.MentionSegmentInput.class);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        Assert.areEqual(restOfMessage, textSegment.text);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(1);
        Assert.areEqual(mentionId, mentionSegment.id);
    }

    @IsTest(SeeAllData=true)
    static void testAdjacentMentions() {
        String mentionId  = '005x0000000URNPzzz';
        String mentionId2 = '0F9x00000000D7m';
        String text = '{' + mentionId + '}' + '{' + mentionId2 + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(2, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MentionSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.MentionSegmentInput.class);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(0);
        Assert.areEqual(mentionId, mentionSegment.id);

        ConnectApi.MentionSegmentInput mentionSegment2 = (ConnectApi.MentionSegmentInput) segments.get(1);
        Assert.areEqual(mentionId2, mentionSegment2.id);
    }

    @IsTest(SeeAllData=true)
    static void testLinkAndHashtagParsing() {
        // The test string is: #Yolo: http://salesforce.com, {005} {005x0000000URNPzzz} test.
        //                     [   ][][                   ][      ][                  ][    ]
        //                     0    1 2                    3       4                   5
        // 0 = hashtag
        // 1 = text1
        // 2 = link
        // 3 = text2
        // 4 = mention
        // 5 = text3

        String hashtag = 'Yolo';
        String text1 = ': ';
        String link = 'http://salesforce.com';
        String text2 = ', {005} ';
        String mentionId = UserInfo.getUserId();
        String text3 = ' test.';
        String text = '#' + hashtag + text1 + link + text2 + '{' + mentionId + '}' + text3;

        ConnectApi.FeedElement fi = ConnectApiHelper.postFeedItemWithRichText(null, 'me', text);

        List<ConnectApi.MessageSegment> segments = fi.body.messageSegments;

        Assert.areEqual(6, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.HashtagSegment.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.TextSegment.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.LinkSegment.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.TextSegment.class);
        Assert.isInstanceOfType(segments.get(4), ConnectApi.MentionSegment.class);
        Assert.isInstanceOfType(segments.get(5), ConnectApi.TextSegment.class);

        ConnectApi.HashtagSegment hashtagSegment = (ConnectApi.HashtagSegment) segments.get(0);
        Assert.areEqual(hashtag, hashtagSegment.tag);

        ConnectApi.TextSegment textSegment1 = (ConnectApi.TextSegment) segments.get(1);
        Assert.areEqual(text1, textSegment1.text);

        ConnectApi.LinkSegment linkSegment = (ConnectApi.LinkSegment) segments.get(2);
        Assert.areEqual(link, linkSegment.url);

        ConnectApi.TextSegment textSegment2 = (ConnectApi.TextSegment) segments.get(3);
        Assert.areEqual(text2, textSegment2.text);

        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(4);
        Assert.areEqual(mentionId, mentionSegment.record.id);

        ConnectApi.TextSegment textSegment3 = (ConnectApi.TextSegment) segments.get(5);
        Assert.areEqual(text3, textSegment3.text);
    }

    @IsTest(SeeAllData=true)
    static void testMentionInComment() {
        ConnectApi.FeedElement fi = ConnectApi.ChatterFeeds.postFeedElement(null, 'me', ConnectApi.FeedElementType.FeedItem, 'hi');
        String mentionId = UserInfo.getUserId();
        String text = '{' + mentionId + '}';
        ConnectApi.Comment comment = ConnectApiHelper.postCommentWithMentions(null, fi.id, text);

        List<ConnectApi.MessageSegment> segments = comment.body.messageSegments;
        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MentionSegment.class);
        ConnectApi.MentionSegment mentionSegment = (ConnectApi.MentionSegment) segments.get(0);
        Assert.areEqual(mentionId, mentionSegment.record.id);
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBody() {

        // We'll post a feed item that contains text, link, hashtag, mention, and markup segments,
        // and then call the helper method on the resulting body.

        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();

        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        // We can put the link and hashtag parts into a text segment to post the feed item. When it gets retrieved, it will have
        // separate segments for the text, link and hashtag.
        String expectedText = 'Text ';
        String expectedLink = 'http://link.com';
        String expectedHashtag = 'hashtag';
        String expectedBoldText = 'Bold text';

        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = expectedText + expectedLink + ' #' + expectedHashtag;
        messageBodyInput.messageSegments.add(textSegmentInput);

        ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
        mentionSegmentInput.id = UserInfo.getUserId();
        messageBodyInput.messageSegments.add(mentionSegmentInput);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegmentInput = new ConnectApi.MarkupBeginSegmentInput();
        markupBeginSegmentInput.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupBeginSegmentInput);

        textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = expectedBoldText;
        messageBodyInput.messageSegments.add(textSegmentInput);

        ConnectApi.MarkupEndSegmentInput markupEndSegmentInput = new ConnectApi.MarkupEndSegmentInput();
        markupEndSegmentInput.markupType = ConnectApi.MarkupType.Bold;
        messageBodyInput.messageSegments.add(markupEndSegmentInput);

        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = UserInfo.getUserId();

        ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput);

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(feedElement.body);
        Assert.areEqual(8, input.messageSegments.size(), 'Wrong number of message segments.');

        Assert.isInstanceOfType(input.messageSegments.get(0),  ConnectApi.TextSegmentInput.class, 'Segment 0 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput = (ConnectApi.TextSegmentInput) input.messageSegments.get(0);
        Assert.areEqual(expectedText, textInput.text, 'Segment 0 text does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(1),  ConnectApi.LinkSegmentInput.class, 'Segment 1 is not a link segment input.');
        ConnectApi.LinkSegmentInput linkInput = (ConnectApi.LinkSegmentInput) input.messageSegments.get(1);
        Assert.areEqual(expectedLink, linkInput.url, 'Segment 1 url does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(2),  ConnectApi.TextSegmentInput.class, 'Segment 2 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput2 = (ConnectApi.TextSegmentInput) input.messageSegments.get(2);
        Assert.areEqual(' ', textInput2.text, 'Segment 2 text does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(3),  ConnectApi.HashtagSegmentInput.class, 'Segment 3 is not a hashtag segment input.');
        ConnectApi.HashtagSegmentInput hashtagInput = (ConnectApi.HashtagSegmentInput) input.messageSegments.get(3);
        Assert.areEqual(expectedHashtag, hashtagInput.tag, 'Segment 3 hashtag does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(4),  ConnectApi.MentionSegmentInput.class, 'Segment 4 is not a mention segment input.');
        ConnectApi.MentionSegmentInput mentionInput = (ConnectApi.MentionSegmentInput) input.messageSegments.get(4);
        Assert.areEqual(UserInfo.getUserId(), mentionInput.id, 'Segment 4 mention ID does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(5),  ConnectApi.MarkupBeginSegmentInput.class, 'Segment 5 is not a markup begin segment input.');
        ConnectApi.MarkupBeginSegmentInput markupBeginInput = (ConnectApi.MarkupBeginSegmentInput) input.messageSegments.get(5);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupBeginInput.markupType, 'Segment 5 markup type does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(6),  ConnectApi.TextSegmentInput.class, 'Segment 6 is not a text segment input.');
        ConnectApi.TextSegmentInput textInput3 = (ConnectApi.TextSegmentInput) input.messageSegments.get(6);
        Assert.areEqual(expectedBoldText, textInput3.text, 'Segment 6 text does not match.');

        Assert.isInstanceOfType(input.messageSegments.get(7),  ConnectApi.MarkupEndSegmentInput.class, 'Segment 7 is not a markup end segment input.');
        ConnectApi.MarkupEndSegmentInput markupEndInput = (ConnectApi.MarkupEndSegmentInput) input.messageSegments.get(7);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupEndInput.markupType, 'Segment 7 markup type does not match.');

        // Get coverage for the createFeedItemInputFromBody() method.
        ConnectApi.FeedItemInput feedItemInput2 = ConnectApiHelper.createFeedItemInputFromBody(feedElement.body);
        Assert.areEqual(input, feedItemInput2.body, 'createFeedItemInputFromBody is returning a different input body than createInputFromBody.');

        // Get coverage for the createCommentInputFromBody() method.
        ConnectApi.CommentInput commentInput = ConnectApiHelper.createCommentInputFromBody(feedElement.body);
        Assert.areEqual(input, commentInput.body, 'createCommentInputFromBody is returning a different input body than createInputFromBody.');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithGeneratedSegment() {
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an entity link segment.
        ConnectApi.EntityLinkSegment entityLinkSegment = new ConnectApi.EntityLinkSegment();
        entityLinkSegment.text = 'blah';

        body.messageSegments.add(entityLinkSegment);
        body.text = 'blah';

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        Assert.areEqual(0, input.messageSegments.size(), 'Wrong number of message segments.');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithNewLine() {
        // In order for newlines to display properly in rich text, they need to be turned into
        // paragraph markup segments.
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an text segment containing a newline character.
        ConnectApi.TextSegment textSegment = new ConnectApi.TextSegment();
        String newline = EncodingUtil.urlDecode('%0A', 'UTF-8'); 
        textSegment.text = 'foo' + newline + 'bar';

        body.messageSegments.add(textSegment);
        body.text = textSegment.text;

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        // We expect 4 segments:
        // 1. TextSegmentInput 'foo'
        // 2. MarkupBeginSegmentInput for <p>
        // 3. MarkupEndSegmentInput for <p>
        // 4. TextSegmentInput 'bar'
        Assert.areEqual(4, input.messageSegments.size(), 'Wrong number of message segments.');
        Assert.isInstanceOfType(input.messageSegments[0], ConnectApi.TextSegmentInput.class, 'Wrong type for input 0');
        Assert.isInstanceOfType(input.messageSegments[1], ConnectApi.MarkupBeginSegmentInput.class, 'Wrong type for input 1');
        Assert.isInstanceOfType(input.messageSegments[2], ConnectApi.MarkupEndSegmentInput.class, 'Wrong type for input 2');
        Assert.isInstanceOfType(input.messageSegments[3], ConnectApi.TextSegmentInput.class, 'Wrong type for input 3');
    }

    @IsTest(SeeAllData=true)
    static void testCreateInputFromBodyWithTwoNewLines() {
        // In order for newlines to display properly in rich text, they need to be turned into
        // paragraph markup segments.
        
        ConnectApi.FeedBody body = new ConnectApi.FeedBody();
        body.messageSegments = new List<ConnectApi.MessageSegment>();

        // Mock up an text segment containing a newline character.
        ConnectApi.TextSegment textSegment = new ConnectApi.TextSegment();
        String newline = EncodingUtil.urlDecode('%0A', 'UTF-8'); 
        textSegment.text = 'foo' + newline + newline + 'bar';

        body.messageSegments.add(textSegment);
        body.text = textSegment.text;

        ConnectApi.MessageBodyInput input = ConnectApiHelper.createInputFromBody(body);
        // We expect 5 segments:
        // 1. TextSegmentInput 'foo'
        // 2. MarkupBeginSegmentInput for <p>
        // 3. TextSegmentInput '&nbsp;'
        // 4. MarkupEndSegmentInput for <p>
        // 5. TextSegmentInput 'bar'
        Assert.areEqual(5, input.messageSegments.size(), 'Wrong number of message segments.');
        Assert.isInstanceOfType(input.messageSegments[0], ConnectApi.TextSegmentInput.class, 'Wrong type for input 0');
        Assert.isInstanceOfType(input.messageSegments[1], ConnectApi.MarkupBeginSegmentInput.class, 'Wrong type for input 1');
        Assert.isInstanceOfType(input.messageSegments[2], ConnectApi.TextSegmentInput.class, 'Wrong type for input 2');
        Assert.isInstanceOfType(input.messageSegments[3], ConnectApi.MarkupEndSegmentInput.class, 'Wrong type for input 3');
        Assert.isInstanceOfType(input.messageSegments[4], ConnectApi.TextSegmentInput.class, 'Wrong type for input 4');
    }
    
    @IsTest(SeeAllData=true)
    static void testUnsupportedMarkup() {
        // <span>a</span>, <h1><a>b</a> <br> <b>Does this work?</b></h1>
        // [0                               ][1][2            ][3 ][4  ]
        // 0 = text1
        // 1 = markup begin
        // 2 = text2
        // 3 = markup end
        // 4 = text3
        String text1 = '<span>a</span>, <h1><a>b</a> <br> ';
        String text2 = 'Does this work?';
        String text3 = '</h1>';
        String text = text1 + '<b>' + text2 + '</b>' + text3;

        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(5, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(4), ConnectApi.TextSegmentInput.class);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        Assert.areEqual(text1, textSegment.text);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        Assert.areEqual(text2, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        Assert.areEqual(text3, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testSimpleMarkup() {
        String restOfMessage = 'blah';
        String text = '<u>' + restOfMessage + '</u>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(3, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.MarkupEndSegmentInput.class);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        Assert.areEqual(restOfMessage, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testMarkupCasing() {
        String text1 = 'foo';
        String text2 = 'bar';
        String text3 = 'baz';
        String text = '<U>' + text1 + '</U><b>' + text2 + '</B><oL><li>' + text3 + '</li></oL>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(11, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(4), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(5), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(6), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(7), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(8), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(9), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(10), ConnectApi.MarkupEndSegmentInput.class);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        Assert.areEqual(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(2);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(3);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(4);
        Assert.areEqual(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(5);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        Assert.areEqual(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        Assert.areEqual(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        Assert.areEqual(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImage() {
        String restOfMessage = 'Check out this image!';
        String imageId = '069B0000000q7hi';
        String altText = 'Some alt text.';
        String text = restOfMessage + '{img:' + imageId + ':' + altText + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(2, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.InlineImageSegmentInput.class);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(0);
        Assert.areEqual(restOfMessage, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        Assert.areEqual(imageId, inlineImageSegment.fileId);
        Assert.areEqual(altText, inlineImageSegment.altText);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImageNoAltText() {
        String imageId = '069B0000000q7hi';
        String text = '{img:' + imageId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.InlineImageSegmentInput.class);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        Assert.areEqual(imageId, inlineImageSegment.fileId);
        Assert.areEqual(null, inlineImageSegment.altText);
    }

    @IsTest(SeeAllData=true)
    static void testInlineImageAltTextSyntax() {
        String imageId15 = '069B0000000q7hi';
        String imageId18 = '069B0000000q7hixxx';
        String altText1 = 'Alt text with a colon : in the middle.';
        String badSyntax1 = 'Alt text with a closing brace ';
        String badSyntax2 = ' in the middle.}';
        String badSyntaxAltText = badSyntax1 + '}' + badSyntax2;
        String text = '{img:' + imageId15 + ':' + altText1 + '}{img:' + imageId18 + ':}{img:' + imageId15 + ':' + badSyntaxAltText;
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(4, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.InlineImageSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.InlineImageSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.InlineImageSegmentInput.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.TextSegmentInput.class);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(0);
        Assert.areEqual(imageId15, inlineImageSegment.fileId);
        Assert.areEqual(altText1, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(1);
        Assert.areEqual(imageId18, inlineImageSegment.fileId);
        Assert.areEqual(null, inlineImageSegment.altText);

        inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(2);
        Assert.areEqual(imageId15, inlineImageSegment.fileId);
        Assert.areEqual(badSyntax1, inlineImageSegment.altText);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(3);
        Assert.areEqual(badSyntax2, textSegment.text);
    }

    @IsTest(SeeAllData=true)
    static void testRecordMention18CharId() {
        String recordId = '01t3E000002GCm9QAG';
        String text = '{record:' + recordId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.EntityLinkSegmentInput.class);

        ConnectApi.EntityLinkSegmentInput recordSegment = (ConnectApi.EntityLinkSegmentInput) segments.get(0);
        Assert.areEqual(recordId, recordSegment.entityId);
    }

    @IsTest(SeeAllData=true)
    static void testRecordMention15CharId() {
        String recordId = '01t3E000002GCm9';
        String text = '{record:' + recordId + '}';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(1, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.EntityLinkSegmentInput.class);

        ConnectApi.EntityLinkSegmentInput recordSegment = (ConnectApi.EntityLinkSegmentInput) segments.get(0);
        Assert.areEqual(recordId, recordSegment.entityId);
    }

    @IsTest(SeeAllData=true)
    static void testMarkupAndMention() {
        String mentionId = '005x0000000URNPzzz';
        String message = 'How are you';
        String questionMark = '?';
        String text = '<b>' + message + '<i>{' + mentionId + '}</i>' + questionMark + '</b>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(7, segments.size());
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.MentionSegmentInput.class);
        Assert.isInstanceOfType(segments.get(4), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(5), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(6), ConnectApi.MarkupEndSegmentInput.class);

        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(1);
        Assert.areEqual(message, textSegment.text);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(2);
        Assert.areEqual(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.MentionSegmentInput mentionSegment = (ConnectApi.MentionSegmentInput) segments.get(3);
        Assert.areEqual(mentionId, mentionSegment.id);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        Assert.areEqual(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(5);
        Assert.areEqual(questionMark, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(6);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);
    }

    @IsTest(SeeAllData=true)
    static void testAllMarkupAndInlineImage() {
        // <p><i>This is an italicized paragraph.</i></p>
        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        // <code>int foo = 1 / 0;</code>
        String text1 = 'This is an italicized paragraph.';
        String text2 = 'A completed item in an unordered list.';
        String text3 = 'An underlined item in an ordered list.';
        String text4 = 'And, of course, an image for you: ';
        String text5 = ' ';
        String imageId = '069B0000000q7hi';
        String altText = 'An image of something nice.';
        String code = 'int foo = 1 / 0;';
        String text = '<p><i>' + text1 + '</i></p><ul><li><s>' + text2 + '</s></li></ul><ol><li><u>'
                        + text3 + '</u></li></ol><b>' + text4 + '</b> {img:' + imageId + ':' + altText + '}'
                        + '<code>' + code + '</code>';
        List<ConnectApi.MessageSegmentInput> segments = ConnectApiHelper.getMessageSegmentInputs(text);

        Assert.areEqual(27, segments.size());
        // <p><i>This is an italicized paragraph.</i></p>
        Assert.isInstanceOfType(segments.get(0), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(1), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(2), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(3), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(4), ConnectApi.MarkupEndSegmentInput.class);

        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        Assert.isInstanceOfType(segments.get(5), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(6), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(7), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(8), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(9), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(10), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(11), ConnectApi.MarkupEndSegmentInput.class);

        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        Assert.isInstanceOfType(segments.get(12), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(13), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(14), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(15), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(16), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(17), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(18), ConnectApi.MarkupEndSegmentInput.class);

        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        Assert.isInstanceOfType(segments.get(19), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(20), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(21), ConnectApi.MarkupEndSegmentInput.class);
        Assert.isInstanceOfType(segments.get(22), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(23), ConnectApi.InlineImageSegmentInput.class);

        // <code>int foo = 1 / 0;</code>
        Assert.isInstanceOfType(segments.get(24), ConnectApi.MarkupBeginSegmentInput.class);
        Assert.isInstanceOfType(segments.get(25), ConnectApi.TextSegmentInput.class);
        Assert.isInstanceOfType(segments.get(26), ConnectApi.MarkupEndSegmentInput.class);

        // <p><i>This is an italicized paragraph.</i></p>
        ConnectApi.MarkupBeginSegmentInput markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(0);
        Assert.areEqual(ConnectApi.MarkupType.Paragraph, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(1);
        Assert.areEqual(ConnectApi.MarkupType.Italic, markupBeginSegment.markupType);

        ConnectApi.TextSegmentInput textSegment = (ConnectApi.TextSegmentInput) segments.get(2);
        Assert.areEqual(text1, textSegment.text);

        ConnectApi.MarkupEndSegmentInput markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(3);
        Assert.areEqual(ConnectApi.MarkupType.Italic, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(4);
        Assert.areEqual(ConnectApi.MarkupType.Paragraph, markupEndSegment.markupType);

        // <ul><li><s>A completed item in an unordered list.</s></li></ul>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(5);
        Assert.areEqual(ConnectApi.MarkupType.UnorderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(6);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(7);
        Assert.areEqual(ConnectApi.MarkupType.Strikethrough, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(8);
        Assert.areEqual(text2, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(9);
        Assert.areEqual(ConnectApi.MarkupType.Strikethrough, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(10);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(11);
        Assert.areEqual(ConnectApi.MarkupType.UnorderedList, markupEndSegment.markupType);

        // <ol><li><u>An underlined item in an ordered list.</u></li></ol>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(12);
        Assert.areEqual(ConnectApi.MarkupType.OrderedList, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(13);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupBeginSegment.markupType);

        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(14);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(15);
        Assert.areEqual(text3, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(16);
        Assert.areEqual(ConnectApi.MarkupType.Underline, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(17);
        Assert.areEqual(ConnectApi.MarkupType.ListItem, markupEndSegment.markupType);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(18);
        Assert.areEqual(ConnectApi.MarkupType.OrderedList, markupEndSegment.markupType);

        // <b>And, of course, an image for you:</b> {img:069B0000000q7hi:An image of something nice.}
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(19);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(20);
        Assert.areEqual(text4, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(21);
        Assert.areEqual(ConnectApi.MarkupType.Bold, markupEndSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(22);
        Assert.areEqual(text5, textSegment.text);

        ConnectApi.InlineImageSegmentInput inlineImageSegment = (ConnectApi.InlineImageSegmentInput) segments.get(23);
        Assert.areEqual(imageId, inlineImageSegment.fileId);
        Assert.areEqual(altText, inlineImageSegment.altText);

        // <code>int foo = 1 / 0;</code>
        markupBeginSegment = (ConnectApi.MarkupBeginSegmentInput) segments.get(24);
        Assert.areEqual(ConnectApi.MarkupType.Code, markupBeginSegment.markupType);

        textSegment = (ConnectApi.TextSegmentInput) segments.get(25);
        Assert.areEqual(code, textSegment.text);

        markupEndSegment = (ConnectApi.MarkupEndSegmentInput) segments.get(26);
        Assert.areEqual(ConnectApi.MarkupType.Code, markupEndSegment.markupType);

    }
}

