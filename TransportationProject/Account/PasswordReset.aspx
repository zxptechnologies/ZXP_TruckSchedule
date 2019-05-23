<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="PasswordReset.aspx.cs" Inherits="TransportationProject.Account.PasswordReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Reset Password</h2>
   
    <p>
       Enter Password: <asp:TextBox id="txtEnterPassword" TextMode="Password" runat="server"></asp:TextBox>
         <span style="color:red"><asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
             ErrorMessage="Password Required" 
             ControlToValidate="txtEnterPassword"
             CssClass="ValidationError"
            ToolTip="Password is required"
            ></asp:RequiredFieldValidator></span>
    </p>
    <p>
       Confirm Password: <asp:TextBox ID="txtConfirmPassword" TextMode="Password" runat="server"></asp:TextBox>
        <span style="color:red"> <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
             ErrorMessage="Password Required" 
             ControlToValidate="txtConfirmPassword"
             CssClass="ValidationError"
            ToolTip="Password is required"
            ></asp:RequiredFieldValidator></span>
       
    </p>
     <p>
        <span style="color:red">
        <asp:CompareValidator ID="CompareValidator2" runat="server" 
             ControlToValidate="txtConfirmPassword"
             CssClass="ValidationError"
             ControlToCompare="txtEnterPassword"
             ErrorMessage="Passwords must match" 
             ToolTip="Password must be the same" /></span>
       
    </p>
    <asp:HiddenField id="token" runat="server" />
    <p>
       <asp:Button id="Button2" runat="server" Text="Submit" OnClick="ResetPassword" />
    </p>
     <p>
         <span style ="color:red">
             <asp:Label ID="uMessage" runat="server" Text=""></asp:Label>
        </span>
    </p>

</asp:Content>
