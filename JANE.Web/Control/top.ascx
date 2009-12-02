<%@ Control Language="C#" AutoEventWireup="true" %>
<script type="text/javascript">
    var menuData = {
        "home": { text: "��ҳ", url: "/" },
        "news": { text: "��Ѷ", url: "/news.html" },
        "calender": { text: "�г�", url: "/calender.html" },
        "singer": { text: "����", url: "/singer.html" },
        "music": { text: "��Ƭ", url: "/music.html" },
        "video": { text: "��Ƶ", url: "/video.html" },
        "photo": { text: "ͼƬ", url: "/photo.html" },
        "bbs": { text: "��̳", url: "http://bbs.janezhang.com", target: "_blank" },
        "shop": { text: "�̳�", url: "/shop.html" }
    };
    var channel = "<%=channel %>" ;
    menuData[channel].isCurrent = true;
    function menuReady(func) {
        var flash = window["menu"] || document["menu"];
        setTimeout(function() {
            flash.setMenu(menuData);
        }, 500);
    }
</script>
<div class="head">
  <div class="head_login">
   <%if (D4D.Web.Helper.AdminHelper.CurrentUser == null)
          { %>
  <a href="#" id="btnLogin">��¼</a> | <a href="http://bbs.janezhang.com/register.aspx?agree=yes">ע��</a>
  <div style="display:none"><div class="login" id="loginForm">
    <iframe style="width:398px; height:240px; position:absolute;z-index:-1; top:0; left:0; border:0;"></iframe>
    <form action="/svc/user.svc/Login">
	  <div class="login_title">
		<h1 class="font14">��¼����ӱ�ٷ���վ</h1>
		<span onclick="$.unblockUI()"><img src="/static/images/ico_close_01.gif" /></span>
	  </div>
	  <div class="spacer" style="height:30px"></div>
	  <div class="login_row">
		<div class="login_row_name font14 floatleft">
		  �û����֣�
		</div>
		<div class="login_row_con floatright">
			<input type="text" name="username" style="width:180px; height:16px;line-height:16px;" class="input_02 font14" />
		</div>
		<div class="clear"></div>
	  </div>
	  <div class="spacer"></div>
	  <div class="spacer"></div>
	  <div class="login_row">
		<div class="login_row_name font14 floatleft">
		  ��&nbsp;&nbsp;&nbsp;&nbsp;�룺
		</div>
		<div class="login_row_con floatright">
			<input type="password" name="password" style="width:180px; height:16px;line-height:16px;" class="input_02 font14" />
		</div>
		<div class="clear"></div>
	  </div>
	  
	  <div class="spacer"></div>
	  <div class="spacer"></div>
	  <div class="login_row">
		<div class="login_row_name font14 floatleft">
		 &nbsp;
		</div>
		<div class="login_row_con floatright">
			<input type="submit" value="��¼" />
			<div class="vspacer"></div>
			<div class="floatleft" style="line-height:20px"><a href="http://bbs.janezhang.com/register.aspx?agree=yes">����ע��</a> | <a href="http://bbs.janezhang.com/getpassword.aspx">��������</a></div>	
		</div>
		<div class="clear"></div>
	  </div>
	  
	  <div class="spacer"></div>
	  <div class="spacer"></div>
	  
	  
	  <div class="login_foot">��¼����ӱ�ٷ���վ����ø��ྫ����Ѷ</div>
	  <div class="spacer"></div>
	</div></div>
   <%}
          else
          { %>
          <label><%=D4D.Web.Helper.AdminHelper.CurrentUser.UserName %></label> | <a href="#" id="logout">�˳���¼</a>
        <%} %>
| <a href="#">����ѡ��</a><img src="/static/images/ico_arrow.gif" align="absmiddle" />
  </div>
  <div>
  <script type="text/javascript">
          AC_FL_RunContent(
		"src", "/static/images/menu",
		"width", "1300",
		"height", "40",
		"align", "middle",
		"id", "menu",
		"quality", "high",
		"name", "menu",
		"allowScriptAccess", "always",
		"wmode","transparent",
		"type", "application/x-shockwave-flash",
		"pluginspage", "http://www.adobe.com/go/getflashplayer"
	);
</script>  
  
  </div>
</div>
<script type="text/javascript">
    $(document).ready(function() {
        $("#loginForm form").ajaxForm(
        { success: function(response) {
            if (response.d && response.d.UserId > 0) {
                $.unblockUI();
                alert("��¼�ɹ�");
                location.reload();
            } else {
                alert("��������û�����������������");
            }
        }, dataType: "json"
        })
        .find("a:eq(0)").click(function() {
            $("#loginForm form").submit();
        });

        $('#btnLogin').click(function() {
            $.blockUI({ message: $('#loginForm'),
                css: {
                    width: 396,
                    left: ($(window).width() - 396) / 2,
                    top: ($(window).height() - 300) / 2,
                    border: "none"                    
                }
            });
            $('.blockOverlay').attr('title', '���ȡ����½').click($.unblockUI);

        });
        $("#logout").click(function() {
            $.getJSON("/svc/user.svc/LoginOut");
            window.location.reload();
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
    private string channel = "home";
    protected string GetMenu( string str)
    {

        if (str == channel) return "";
        else return "off_";
        
    }
    
</script>