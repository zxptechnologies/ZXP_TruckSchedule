<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="whoami.aspx.cs" Inherits="TransportationProject.whoami" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>


    <script>
        
        function onSuccess_GetLoggedInUser(value, ctx, methodName) {
            var username = value["_UserName"];
            var userID = value["_uid"];
            var isAdmin = value["_isAdmin"];
            var isGuard = value["_isGuard"];
            var isAcctMgr = value["_isAccountManager"];
            $("#username").text(username);
            $("#userID").text(userID);
            $("#isAdmin").text(isAdmin);
            $("#isGuard").text(isGuard);
            $("#isAcctMgr").text(isAcctMgr);
        }

        function onFail_GetLoggedInUser(){
            sendtoErrorPage("Error in Whoami.aspx onFail_GetLoggedInUser");
        }

        $(function () {
            PageMethods.GetLoggedInUser(onSuccess_GetLoggedInUser, onFail_GetLoggedInUser);
        });
    
    </script>
    <h1>You are:</h1><div id="username"></div>
    <h1>UserID:</h1><div id="userID"></div>
    <h1>Admin:</h1><div id="isAdmin"></div>
    <h1>Guard:</h1><div id="isGuard"></div>
    <h1>Acct Mgr:</h1><div id="isAcctMgr"></div>
</asp:Content>
