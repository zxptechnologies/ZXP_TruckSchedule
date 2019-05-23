<%@ Page Title="ZXP Truck Schedule Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TransportationProject._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1><%: Title %>.</h1>
                <h2>Welcome!</h2>
            </hgroup>
            <p>
               Select a page to view from the list <mark>below</mark>
            </p>
        </div>
    </section>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <asp:ScriptManager ID="ScriptManager1"  runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">


        /*-----------------Functions-----------------------*/
        function getNumberstrTitleForCSSClass(num) {
            var strNum = "";
            switch (num)
            { 
                case 1:
                    strNum = "one";
                    break;
                case 2:
                    strNum = "two";
                    break;
                case 3:
                    strNum = "three";
                    break;
                case 4:
                    strNum = "four";
                    break;
                case 5:
                    strNum = "five";
                    break;
                case 6:
                    strNum = "six";
                    break;
                case 7:
                    strNum = "seven";
                    break;
                case 8:
                    strNum = "eight";
                    break;
                case 9:
                    strNum = "nine";
                    break;
                  case 10:
                    strNum = "ten";
                    break;
                  case 11:
                    strNum = "eleven";
                    break;
                  case 12:
                    strNum = "twelve";
                    break;
                  case 13:
                    strNum = "thirteen";
                    break;
            
            }
            return strNum;
        
        }


        function onSuccess_getMenuSummaryItems(value, ctx, methodName) {
  
            for (i = 0; i < value.length; i++) {
                var itemUrl = value[i].strURL;
                var itemText = value[i].strTitle;
                var itemSummary = value[i].strSummary;
                
                <%-- //adds an image 1-9 before menuitem ; removed because menuitem counte is greater than 9
                var itemClass = getNumberstrTitleForCSSClass(i+1); 
                var newMenuItem = "<li class='" + itemClass + "'><h5>" + itemText + "</h5>" + itemSummary + "<a href='" + itemUrl + "'>Go to page</a></li>";
                --%>

                 var newMenuItem = "<li><h5>" + (i+1) + " " + itemText + "</h5>" + itemSummary + "<a href='" + itemUrl + "'>Go to page</a></li>";
                $("#MenuSummary").append(newMenuItem);
            }
        }

        function onFail_getMenuSummaryItems(value, ctx, methodName) {
            sendtoErrorPage("Error in Default.aspx, onFail_getMenuSummaryItems");
        }

        $(function ()
        {
            $(".arrowGridScrollButtons").hide();
            PageMethods.getMenuSummaryItems(onSuccess_getMenuSummaryItems, onFail_getMenuSummaryItems);
        });
        

    </script>
    <h3>The Truck Schedule Application:</h3>

    <ol id="MenuSummary" class="round">
       <%-- <li class="one">
            <h5>Trailer Overview</h5>
            View, create, edit, and delete schedule for trucks
            <a href="trailerOverview.aspx">Go to page</a>
        </li>
        <li class="two">
            <h5>Inspection</h5>
           View, create, edit, and delete inspections for a PO
            <a href="inspection.aspx">Go to page</a>
        </li>
        <li class="three">
            <h5>Samples</h5>
            View, create, edit, and delete samples
            <a href="Samples.aspx">Go to page</a>
        </li>
        <li class="four">
            <h5>Waiting Area & Dock Spots</h5>
            View trucks and their current location and status
            <a href="waitAndDockOverview.aspx">Go to page</a>
        </li>
        <li class="five">
            <h5>Dock Manager</h5>
            Assign, edit, and view current requests for loaders and yardmule
            <a href="dockManager.aspx">Go to page</a>
        </li>
        <li class="six">
            <h5>Loader Request</h5>
            View requests for Loader
            <a href="loaderTimeTracking.aspx">Go to page</a>
        </li>
        <li class="seven">
            <h5>Yard Mule Requests</h5>
            View requests for Yard Mule
            <a href="yardMuleRequestOverview.aspx">Go to page</a>
        </li>
        <li class="eight">
            <h5>Pattern</h5>
            View loading patterns available
            <a href="patternList.aspx">Go to page</a>
        </li>
        <li class="nine">
            <h5>Admin</h5>
            View Admin page for creating, editing  and deleting application related data 
            <a href="AdminMainPage.aspx">Go to page</a>
        </li>--%>
    </ol>
</asp:Content>
