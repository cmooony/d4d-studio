﻿<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/MasterPage/Channel.Master" %>
<%@ Import Namespace="D4D.Platform.Domain" %>
<%@ Import Namespace="D4D.Platform" %>
<%@ Import Namespace="System.Collections.Generic" %>
<asp:Content ContentPlaceHolderID="ContentHeader" runat="server" ID="ContentHeader">
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentMain" runat="server">
<div class="main">
<div class="channel">
  <h1>评论: <a href="/photo/album/<%=Current.AlbumId%>/slider.html"><%=Current.Title%></a></h1>
</div>

<ul class="comments">
    <%  bool isAdmin = (D4D.Web.Helper.AdminHelper.CurrentUser!=null &&　D4D.Web.Helper.AdminHelper.CurrentUser.UserType.Trim() == ((int)LTP.Accounts.Bus.UserType.Type.Admin).ToString());
        for (int i = 0; i < CommentList.Count; i++)
      {
          Comment item = CommentList[i];%>
	<li>
    	<p>
    	    <%=item.UserName%> 发表于<label> <%=item.AddDate.ToString("yyyy-MM-dd HH:mm:ss")%></label>
    	    <%if(isAdmin){ %><del cid="<%=item.CommentId%>">删除</del><%} %>
    	</p>
    	<p><%=item.Body%></p>
    </li>
    <%} %>
</ul>
<div class="pagestyle" id="pager"></div>
</div>
<%if (isAdmin)
  { %>
<script type="text/javascript">
    $(document).ready(function() {
        $("del").click(function() {
            if (confirm("确认删除？")) {
                var $self = $(this);
                $.getJSON("/svc/comments.svc/Delete",
                        { id: $self.attr("cid") },
                        function(response) {
                            if (response.d > 0) {
                                alert("删除成功");
                                $self.closest("li").remove();
                            } else if (response.d == -1) {
                                alert("请重新登陆");
                            } else {
                                alert("删除失败");
                            }
                        }
                );
            }
        });
    });
</script>
<%} %>
<script type="text/javascript">
    $(document).ready(function() {
        var cur = parseInt("<%=PageIndex %>");
        var total = parseInt("<%=PageTotalCount %>");
        var pageSize = parseInt("<%=PageSize %>");
        var href = location.pathname;
        if (location.search) {
            if (!location.search.match(/page=\d+/ig)) {
                href += location.search + "&page=__id__";
            } else {
                href += location.search;
            }
        } else {
            href += "?page=__id__";
        }
        $("#pager").pagination(
          total,
                {
                    items_per_page: pageSize,
                    num_display_entries: pageSize,
                    current_page: cur - 1,
                    num_edge_entries: 0,
                    link_to: href.replace(/page=\d+/ig, "page=__id__"),
                    prev_text: "上一页",
                    next_text: "下一页",
                    callback: function(id) {
                        return true;
                    }
                });
    });
</script>
</asp:Content>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Bind();
            BindComments();
        }

    }
    protected int BandId
    {
        get
        {
            string queryid = Request.QueryString["bid"];
            if (string.IsNullOrEmpty(queryid)) return -1;

            int id = 0;

            int.TryParse(queryid, out id);
            return id;
        }
    }
    protected int Id
    {
        get
        {
            string queryid = Request.QueryString["id"];
            if (string.IsNullOrEmpty(queryid)) return -1;

            int id = 0;

            int.TryParse(queryid, out id);
            return id;
        }
    }
    protected int PageIndex
    {
        get
        {
            string queryPage = Request.QueryString["page"];
            if (string.IsNullOrEmpty(queryPage)) return 1;

            int page = 1;

            int.TryParse(queryPage, out page);

            if (page == 0) page = 1;

            return page;
        }
    }

    private int totalCount;
    protected int PageTotalCount
    {
        get
        {
            return totalCount;
        }
    }
    protected int PageSize = 10;
    protected static Album Current;
    private void Bind()
    {
        Current = D4DGateway.AlbumProvider.GetAlbum(Id);

    }
    protected  List<Comment> CommentList;
    private void BindComments()
    {
        PagingContext pager = new PagingContext();
        pager.RecordsPerPage = PageSize;
        pager.CurrentPageNumber = PageIndex;
        CommentList = D4DGateway.CommentProvider.GetPagedComments(pager, PublishStatus.Publish, Id, ObjectTypeDefine.Album);
        totalCount = pager.TotalRecordCount;
        
    }
</script>