<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ErrorPage.aspx.cs" Inherits="TransportationProject.ErrorPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <br /><br /><br />
    <h2 style="text-align: center">Error</h2>
    <br />
    <p style ="text-align:center">An error occurred while attempting to retrieve your requested data.</p>
    <p style ="text-align:center"><asp:Label ID="lblErrReason" runat="server" ForeColor="Red"></asp:Label></p>
    <p style="text-align: center">If the error persists, please contact your application or server administrator.</p>
</asp:Content>
