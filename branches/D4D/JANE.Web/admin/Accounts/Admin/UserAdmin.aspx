<%@ Page Language="c#" Codebehind="UserAdmin.aspx.cs" AutoEventWireup="True" Inherits="Maticsoft.Web.Accounts.Admin.UserAdmin" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>用户管理</title>
    <meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    <link href="../../../style.css" type="text/css" rel="stylesheet">
</head>
<body>
    <form id="Form1" method="post" runat="server">
        <div align="center">
            <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center" id="Table1">
                <tr>
                    <td class="TableBody1" valign="top">
                        <table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
                            <tr>
                                <td bgcolor='<%=Application[Session["Style"].ToString()+"xtable_bgcolor"]%>'>
                                    <table bordercolordark='<%=Application[Session["Style"].ToString()+"xtable_bordercolordark"]%>'
                                        cellpadding="5" width="100%" bordercolorlight='<%=Application[Session["Style"].ToString()+"xtable_bordercolorlight"]%>'
                                        border="1" cellspacing="0">
                                        <tr>
                                            <td height="25" bgcolor='<%=Application[Session["Style"].ToString()+"xtable_titlebgcolor"]%>'
                                                align="center">
                                                <b>用户管理</b></td>
                                        </tr>
                                        <tr>
                                            <td height="22" valign="middle">
                                                &nbsp;&nbsp; 快速查询：<asp:DropDownList ID="DropUserType" runat="server" AutoPostBack="True"
                                                    OnSelectedIndexChanged="DropUserType_SelectedIndexChanged">
                                                    <asp:ListItem Value="" Selected="True">全部用户</asp:ListItem>                                                   
                                                    <asp:ListItem Value="AA">管理人员</asp:ListItem>
                                                    <asp:ListItem Value="SC">普通用户</asp:ListItem>
                                                </asp:DropDownList>&nbsp;
                                                <asp:Label ID="Label1" runat="server">用户名关键字：</asp:Label>
                                                <asp:TextBox ID="TextBox1" runat="server" Width="100px" BorderStyle="Groove"></asp:TextBox>
                                                <asp:ImageButton ID="BtnSearch" runat="server" ImageUrl="..\images\button_search.GIF"
                                                    OnClick="BtnSearch_Click"></asp:ImageButton>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                                &nbsp;<a href="../add.aspx">【添加新用户】</a>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                                        <tr id="TrGrid" runat="server">
                                            <td align="left">
                                                ○ 页次：<asp:Label ID="lblpage" runat="server" ForeColor="#E78A29"></asp:Label>/
                                                <asp:Label ID="lblpagesum" runat="server"></asp:Label>，共：<font color="#e78a29"><asp:Label
                                                    ID="lblrowscount" runat="server"></asp:Label></font>条</td>
                                            <td align="right">
                                                <asp:LinkButton ID="btnFirst" runat="server" ForeColor="#E78A29" OnCommand="NavigateToPage"
                                                    CommandArgument="First" CommandName="Pager" Text="首 页">[首 页]</asp:LinkButton><asp:LinkButton
                                                        ID="btnPrev" runat="server" ForeColor="#E78A29" OnCommand="NavigateToPage" CommandArgument="Prev"
                                                        CommandName="Pager" Text="上一页">[上一页]</asp:LinkButton><asp:LinkButton ID="btnNext"
                                                            runat="server" ForeColor="#E78A29" OnCommand="NavigateToPage" CommandArgument="Next"
                                                            CommandName="Pager" Text="下一页">[下一页]</asp:LinkButton><asp:LinkButton ID="btnLast"
                                                                runat="server" ForeColor="#E78A29" OnCommand="NavigateToPage" CommandArgument="Last"
                                                                CommandName="Pager" Text="尾 页">[尾 页]</asp:LinkButton></td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor='<%=Application[Session["Style"].ToString()+"xtable_bgcolor"]%>'>
                                    <asp:DataGrid ID="DataGrid1" runat="server" Width="100%" AutoGenerateColumns="False"
                                        AllowPaging="True" HorizontalAlign="Center" PageSize="20">
                                        <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                        <Columns>
                                           <asp:TemplateColumn HeaderText="编号">
                                                <HeaderStyle HorizontalAlign="Center" Width="30px"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                <ItemTemplate>
                                                    <%# DataGrid1.CurrentPageIndex*DataGrid1.PageSize+DataGrid1.Items.Count+1 %>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn SortExpression="UserID" HeaderText="用户名">
                                                <ItemTemplate>
                                                    <a href='RoleAssignment.aspx?UserID=<%# DataBinder.Eval(Container, "DataItem.UserID") %>&PageIndex=<%# DataGrid1.CurrentPageIndex %>'>
                                                        <%# DataBinder.Eval(Container, "DataItem.UserName") %>
                                                    </a>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn DataField="TrueName" SortExpression="TrueName" ReadOnly="True" HeaderText="真实姓名">
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="Sex" SortExpression="Sex" ReadOnly="True" HeaderText="性别">
                                                <HeaderStyle Width="30px"></HeaderStyle>
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="Phone" ReadOnly="True" HeaderText="联系电话"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="Email" ReadOnly="True" HeaderText="电子邮件"></asp:BoundColumn>
                                            <asp:BoundColumn DataField="DepartmentID" HeaderText="所属公司"></asp:BoundColumn>
                                            <asp:TemplateColumn HeaderText="修改">
                                                <HeaderStyle Width="30px"></HeaderStyle>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="BtnEdit" runat="server" ImageUrl="..\images\button_edit.gif"
                                                        CommandName="BtnEdit"></asp:ImageButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:TemplateColumn HeaderText="删除">
                                                <HeaderStyle Width="30px"></HeaderStyle>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="BtnDel" runat="server" ImageUrl="..\images\button_del.gif" CommandName="BtnDel">
                                                    </asp:ImageButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>
                                            <asp:BoundColumn Visible="False" DataField="UserID" ReadOnly="True" HeaderText="用户ID">
                                                <HeaderStyle Width="30px"></HeaderStyle>
                                            </asp:BoundColumn>
                                        </Columns>
                                        <PagerStyle Font-Size="Medium" HorizontalAlign="Right" Wrap="False" Mode="NumericPages">
                                        </PagerStyle>
                                    </asp:DataGrid>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
