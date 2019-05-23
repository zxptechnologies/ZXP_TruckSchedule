<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true"CodeBehind="patternList.aspx.cs" Inherits="TransportationProject.patternList" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
    <h2>Patterns for: </h2>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">  
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script id="FileTemplate" type ="text/template">
    <div style='float:left'><a href='${PATTERNPATH}${FILENAMENEW}' id='Pattern_${PATTERNID}'>${FILENAMEOLD}</a></div>
    </script>

    <script type="text/javascript">
        
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_GRID_DATA = [];


         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
        function onSuccess_getPatternsGridData(value, ctx, methodName) {
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    GLOBAL_GRID_DATA.push({
                        "PRODUCTID_CMS": value[i][0], "PRODUCTNAME_CMS": value[i][1].trim(),
                        "PATTERNID": value[i][2], "PATTERNNAME": value[i][3],
                        "PATTERNPATH": value[i][4], "FILENAME": value[i][5], "FILENAMENEW": value[i][6]
                    });

                    $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
                    $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                }
                initGrid();
            }
            else {
                alert("No patterns have been assinged to any products for this shipment");
            }
        }


        function onFail_getPatternsGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in patternList.aspx, onFail_getPatternsGridData");
         }
        
        function getPOAndMSID() {
            var PO = sessionStorage.getItem("PO");
            var MSID = sessionStorage.getItem("MSID");
            //PO = 54905; for testing
            document.querySelector("h2").innerHTML = "Patterns for: " + PO;
            PageMethods.getPatternsGridData(MSID, onSuccess_getPatternsGridData, onFail_getPatternsGridData);
        }

         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>        
        function initGrid(){
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: true,
                 renderCheckboxes: true,
                 primaryKey: "PATTERNID",
                 columns:
                     [
                         { headerText: " ", key: "PATTERNID", dataType: "number", hidden: true },
                         { headerText: "Product Number", key: "PRODUCTID_CMS", dataType: "string" },
                         { headerText: "Product Name", key: "PRODUCTNAME_CMS", dataType: "string" },
                         { headerText: "Pattern Name", key: "PATTERNNAME", dataType: "string" },
                         { headerText: "Pattern Location", key: "PATTERNPATH", template: "<div><a href='${PATTERNPATH}${FILENAMENEW}' id='Pattern_${PATTERNID}'>${FILENAME}</a></div>" },
                         //<a href='${PATTERNPATH}${FILENAMENEW}' id='Pattern_${PATTERNID}'>${FILENAME}</a>
                         { headerText: " ", key: "FILENAME", dataType: "string", hidden: true },
                         { headerText: " ", key: "FILENAMENEW", dataType: "string", hidden: true },
                     ],
                 features: [
                     {
                         name: 'Resizing'
                     },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false
                     },
                     {
                         name: 'Sorting'
                     }
                 ]
             }); <%--end of $("#grid").igGrid({--%>
         };<%--function initGrid(){--%>
        


        $(function () {
            getPOAndMSID();
        }); <%--end of $(function () {--%>

        </script>

    
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div id="navButtons">
        <button type="button" id="toLoaderRequest" onclick="location.href = '/loaderTimeTracking.aspx'">Loader Request</button>
    </div>
    <table id="grid"></table>
</asp:Content>