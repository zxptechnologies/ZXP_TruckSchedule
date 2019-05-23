<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="EmailReset.aspx.cs" Inherits="TransportationProject.Account.EmailReset" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">

     <h2>Send Reset Password Email</h2>
   <p> Enter your email address. An email with a reset link will be sent to the address you provide.</p>
   <p>
       <asp:TextBox ID="emailAddress" runat="server"></asp:TextBox>
       <asp:Button ID="submitButton" runat="server" Text="Submit" OnClick="SubmitForm" />
    </p>
     <p>
         <span style ="color:red">
             <asp:Label ID="uMessage" runat="server" Text=""></asp:Label>
        </span>
    </p>

</asp:Content>

