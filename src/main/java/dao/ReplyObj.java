package dao;

public class ReplyObj {
    private int no, feedNo;
    private String id, content, ts;

    public ReplyObj(int no, int feedNo, String id, String content, String ts) {
        this.no = no;
        this.feedNo = feedNo;
        this.id = id;
        this.content = content;
        this.ts = ts;
    }

    public int getNo() { return this.no; }
    public int getFeedNo() { return this.feedNo; }
    public String getId() { return this.id; }
    public String getContent() { return this.content; }
    public String getTs() { return this.ts; }
}
