<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UserType.aspx.cs" Inherits="Maticsoft.Web.Accounts.Admin.UserType" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>�ޱ���ҳ</title>
    <link href="../style/style.css" type="text/css" rel="stylesheet">
</head>
<body text="#000000" bgcolor="#ffffff" marginwidth="0" marginheight="0">
    <form id="Form1" method="post" runat="server">
        <div align="center">
            <table cellspacing="0" cellpadding="5" width="600" align="center" border="0">
                <tr>
                    <td                         align="center" height="25">
                        <b>�û����͹���</b></td>
                </tr>
                <tr>
                    <td height="22" bgcolor='<%=Application[Session["Style"].ToString()+"xtable_bgcolor"]%>'>
                        <table cellspacing="0" bordercolordark='<%=Application[Session["Style"].ToString()+"xtable_bordercolordark"]%>'
                            cellpadding="2" width="100%" bordercolorlight='<%=Application[Session["Style"].ToString()+"xtable_bordercolorlight"]%>'
                            border="1">
                            <tr>
                                <td  align="left" height="25">&nbsp;
                                    ���ͱ��룺
                                    <asp:TextBox ID="txtUserType" runat="server" Width="156"></asp:TextBox></td>
                            </tr>                            
                            <tr>
                                <td height="25" align="left">&nbsp;
                                    ����������
                                    <asp:TextBox ID="txtDescription" runat="server" Width="156"></asp:TextBox>
                                    &nbsp;
                                    <asp:ImageButton ID="BtnAdd" runat="server" ImageUrl="../images/button_add.gif"
                                        ToolTip="����������" OnClick="BtnAdd_Click"></asp:ImageButton>
                                    <asp:Label ID="lbltip2" runat="server" ForeColor="Red"></asp:Label>
                                    
                                    
                                    </td>
                            </tr>
                            
                            <tr>
                                <td valign="middle" align="center" height="30" bgcolor='<%=Application[Session["Style"].ToString()+"xtable_titlebgcolor"]%>'>
                                    <strong>�û������б�</strong></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataGrid ID="DataGrid1" runat="server" Width="100%" DataKeyField="UserType"
                                        CellPadding="0" AutoGenerateColumns="False" >
                                        <FooterStyle Wrap="False"></FooterStyle>
                                        <SelectedItemStyle Wrap="False"></SelectedItemStyle>
                                        <EditItemStyle Wrap="False"></EditItemStyle>
                                        <AlternatingItemStyle Wrap="False"></AlternatingItemStyle>
                                        <ItemStyle Wrap="False"></ItemStyle>
                                        <Columns>
                                            <asp:BoundColumn DataField="UserType" HeaderText="���ͱ���" ReadOnly="True">
                                                <HeaderStyle Width="55px"></HeaderStyle>
                                                <ItemStyle Wrap="False"></ItemStyle>
                                            </asp:BoundColumn>
                                            <asp:BoundColumn DataField="Description" HeaderText="��������">                                                
                                            </asp:BoundColumn>
                                            <asp:EditCommandColumn UpdateText="����" HeaderText="�༭" CancelText="ȡ��" EditText="�༭">
										<HeaderStyle Width="65px"></HeaderStyle>
										<ItemStyle Font-Bold="True" Wrap="False" HorizontalAlign="Center"></ItemStyle>
									</asp:EditCommandColumn>
                                            <asp:TemplateColumn  HeaderText="ɾ��">
                                                <HeaderStyle Width="50px"></HeaderStyle>
                                                <ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
                                                <ItemTemplate>
                                                    <asp:ImageButton ID="btnDelete" runat="server" ImageUrl="..\images\button_del.gif"
                                                        CommandName="Delete"></asp:ImageButton>
                                                </ItemTemplate>
                                            </asp:TemplateColumn>                                            
                                        </Columns>
                                        <PagerStyle Wrap="False"></PagerStyle>
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:DataGrid></td>
                            </tr>                            
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
