<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminMainPage.aspx.cs" Inherits="TransportationProject.AdministratorMainPage" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    
    <script type="text/javascript">

        $(function () {
            <%--ADD CODE AS NECESSARY  --%>
            var menuSize = $('#AdminSubPagesMenu option').size();
            $('#AdminSubPagesMenu').attr("size", menuSize);

            if ($("#AdminMainPageContent").is(':empty')) {
                $("#adminSettings").hide();
            }
            else {
                $("#adminSettings").show();
            }

            $('#NavigationMenu').on('click', function () {
                $("#adminSettings").hide();
            });

        }); <%--end $(function () --%>

        <%-------------------------------------------------------
        Functions
        ---------------------------------------------------------%>
        
        function setIframe(newSrc)
        {
            if(newSrc)
                $("#iframeContent").attr('src', newSrc)
        }

       


    </script>
    <asp:Menu ID="NavigationMenu" runat="server" Orientation="Horizontal" onmenuitemclick="adminMenuItemClick" >
        <Items>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Alerts.aspx" Text="Alerts"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_DockSpots.aspx" Text="Dock Spots"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Inspections.aspx" Text="Inspections"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_InspectionLists.aspx" Text="Inspection Lists"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Patterns.aspx" Text="Patterns"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Tanks.aspx" Text="Tanks"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Users.aspx" Text="Users"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Weights.aspx" Text="Weights"></asp:MenuItem>
            <asp:MenuItem Target="iframeContent" NavigateUrl="~/Admin_Products.aspx" Text="Products"></asp:MenuItem>
        </Items>
    </asp:Menu>

   <%-- <table id ="adminSettings">
        <tr id="asManualWeightInput"><td>Allow manual input for weights: </td><td><input type="checkbox" id="manualWeights"></td></tr>
    </table>--%>






    <%--<nav>
        <ul id="menu">
            <li><a id="A1" runat="server" onclick="setIframe('Admin_Alerts.aspx')">Alerts</a></li>
            <li><a id="A2" runat="server" onclick="setIframe('Admin_CustomerVendorProducts.aspx')">Product Relations</a></li>
            <li><a id="A3" runat="server" onclick="setIframe('Admin_DockSpots.aspx')">Dock Spots</a></li>
            <li><a id="A4" runat="server" onclick="setIframe('Admin_Inspections.aspx')">Inspections</a></li>
            <li><a id="A5" runat="server" onclick="setIframe('Admin_Patterns.aspx')">Patterns</a></li>
            <li><a id="A6" runat="server" onclick="setIframe('Admin_Tanks.aspx')">Tanks</a></li>
            <li><a id="A7" runat="server" onclick="setIframe('Admin_Users.aspx')">Users</a></li>
        </ul>
    </nav>--%>

    

    <%--div id="AdminMainPageBody">
        <div id="AdminMainPageMenuPanel"  >
            
            <select id="AdminSubPagesMenu" class="AdminInnerContent" onchange="setIframe(this.value)" >
              <option value="" selected="selected">Select An Option Below To Manage</option>
                <%--<option value="/AdminSubPages/Admin_UserAlerts.aspx">User Alerts - TEMP!</option>
                <option value="Admin_Alerts.aspx">Alerts</option>
                <option value="Admin_CustomerVendorProducts.aspx">Product Relations</option>
                <option value="Admin_DockSpots.aspx">Dock Spots</option>
                <option value="Admin_Inspections.aspx">Inspections</option>
                <option value="Admin_Patterns.aspx">Pattern Upload</option>
                <option value="Admin_Tanks.aspx">Tanks</option>
                <option value="Admin_Users.aspx">Users</option>
                <%--<a href="AdminSubPages/CustomerProduct.aspx">AdminSubPages/CustomerProduct.aspx</a>
            </select>
        </div>
        <div id="AdminMainPageContent"><iframe style="position: absolute; height: 100%; border: none" id="iframeContent" class="AdminInnerContent"></iframe></div>
    </div></div>--%>
        <div id="AdminMainPageContent"><iframe style="position: absolute; height: 70%; border: none; width:96%" id="iframeContent" name="iframeContent" class="AdminInnerContent" runat="server"></iframe></div>
</asp:Content>
