<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="top.ascx.cs" Inherits="D4D.Web.Control.top" %>
<div class="header">
    <a href="/"><% string logo =D4D.Platform.D4DGateway.CorpInfoProvider.ReadProfileContent("logo").Trim();
if(!string.IsNullOrEmpty(logo)){%><img src="<%=logo%>" alt="�ٳ�ʱ��" /><% }else{%>
    <img src="/static/images/logo.png" alt="�ٳ�ʱ��" /><%}%></a>
    <div class="login">
        ��ӭ�����ٳ�ʱ����
        <%if (D4D.Web.Helper.AdminHelper.CurrentUser == null)
          { %>
        <label>��[<a href="#" id="btnLogin" onclick="return false">��¼</a>]��[<a href="/regist.html">ע��</a>]</label>
        <a id="logout" style="display:none" href="/regist.html">ע��</a>
        <%}
          else
          { %>
         <label><%=D4D.Web.Helper.AdminHelper.CurrentUser.UserName %></label>
         <a id="logout" href="/">ע��</a>
  <%} %></div>
     <div id="loginForm" style="width:500px; padding:15px; display:none; text-align:left">
     	<div style="position:absolute; text-align:right; margin-left:468px; _margin-left:498px; margin-top:-15px;"><a href="javascript:$.unblockUI()"><img src="/static/images/user/close.gif" /></a></div>
     	<table width="470" border="0" cellspacing="0" cellpadding="5">
    		<form action="/svc/user.svc/Login">
     	  <tr>
     	    <td colspan="3" align="left" style="color:red; font-size:24px; font-weight:bold; font-family:'΢���ź�','����';">��Ա��½</td>
     	    </tr>
     	  <tr>
     	    <td colspan="3" align="left" style="border-top:1px solid #e5e5e5; border-bottom:1px solid #e5e5e5; color:#666;">��¼���������࣬��ø���������Ѷ</td>
   	    </tr>
     	  <tr>
     	    <td width="116" height="50" align="right"><label>�û�</label></td>
     	    <td colspan="2" align="left"><input type="text" class="text" name="username" /></td>
   	    </tr>
     	  <tr>
     	    <td align="right"  height="40"><label>����</label></td>
     	    <td colspan="2" align="left"><input type="password" class="text" name="password" /></td>
   	    </tr>
     	  <tr>
     	    <td height="50">&nbsp;</td>
     	    <td width="117" align="left"><input type="image" src="/static/images/user/login.gif" /></td>
     	    <td width="207" align="left"><a href="/regist.html">����ע��</a> | <a href="/forget.html">��������</a></td>
   	      </tr>
        </form>
   	  </table>
  </div>
</div>
<div class="nav">
    <div class="search">
        <form action="/search.html" method="get">
        <input type="image" src="/static/images/search_go.gif" align="absmiddle" style="float: right" />
        <input name="s" type="text" class="text" <%=((String.IsNullOrEmpty(Request["s"]))?"":Request["s"])%> /></form>
    </div>
    <div><a href="/"><img src="/static/images/nav_<%=GetMenu("/") %>03.png" alt="" /></a><a href="/news.html"><img src="/static/images/nav_<%=GetMenu("news") %>04.png" alt="" /></a><a href="/calender.html"><img src="/static/images/nav_<%=GetMenu("calender") %>05.png" alt="" /></a><a href="/singer.html"><img src="/static/images/nav_<%=GetMenu("singer") %>06.png" alt="" /></a><a href="/music.html"><img src="/static/images/nav_<%=GetMenu("music") %>07.png"  alt="" /></a><a href="/video.html"><img src="/static/images/nav_<%=GetMenu("video") %>08.png" alt="" /></a><a href="/photo.html"><img src="/static/images/nav_<%=GetMenu("photo") %>09.png" alt="" /></a></div>
</div>
<script type="text/javascript">
    $(document).ready(function() {
        $("#loginForm form").ajaxForm(
        { success: function(response) {
            if (response.d && response.d.UserId > 0) {
                $.unblockUI();
                alert("��¼�ɹ�");
                $("div.login label").html(response.d.UserName);
                $("#logout").show();
            } else {
                alert("��������û�����������������");
            }
        }, dataType: "json"
        });
        $('#btnLogin').click(function() {
            $.blockUI({ message: $('#loginForm'),
								   css: { 
								   		width:500,
								   		left:($(window).width()-500)/2,
										top: ($(window).height()-$('#loginForm').height())/2,
										border:"2px solid black" } });
            $('.blockOverlay').attr('title', '���ȡ����½').click($.unblockUI);

        });
        $("#logout").click(function() {
            $.getJSON("/svc/user.svc/LoginOut");
            location.refresh();
            return false;
        });
    }); 
</script>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        string[] path = Request.AppRelativeCurrentExecutionFilePath.Split('/');
        if (path.Length >= 3)
        {
            channel = path[2];
        }
    }
    private string channel = "/";
    protected string GetMenu( string str)
    {

        if (str == channel) return "";
        else return "off_";
        
    }
    
</script>