<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_CleanUp.aspx.cs" Inherits="TransportationProject.AdminCleanUp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
<link href="Content/buttonStyles.css" rel="stylesheet" />
<script type="text/javascript">
 
    function initGrid() {
        $("#truckcleanup").igGrid({
            dataSource: [],
            width: "100%",
            virtualization: false,
            autoGenerateColumns: false,
            renderCheckboxes: true,
            primaryKey: "MSID",
            columns:[
                
                    { headerText: "MSID", key: "MSID", dataType: "number", width: "60px" },
                    { headerText: "ETA", key: "ETA", dataType: "date", width: "150px" },
                    {
                        headerText: "Rejected", key: "REJECTED", dataType: "boolean", width: "80px", template: "{{if(${REJECTED})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                    },
                    { headerText: "Is open in CMS", dataType: "string", key: "isOpenInCMS", width: "50px" },
                    { headerText: "Drop Trailer", key: "DROP", dataType: "bool", width: "70px" },
                    { headerText: "PO", key: "PONUM", dataType: "string", width: "100px" },
                    { headerText: "Customer Order#", key: "ZXPPONUM", dataType: "string", width: "100px" },
                    { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true},
                    {
                        headerText: "Product", key: "PRODID", dataType: "string", width: "150px", template: "{{if(${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                            "{{else}}Multiple{{/if}}"
                    },
                    { headerText: "Truck Type", key: "TRUCKTYPE", dataType: "string", width: "60px" },
                    { headerText: "Status", key: "STATIDTEXT", dataType: "string", width: "150px" },
                    { headerText: "Location", key: "LOCATION", dataType: "string", width: "150px" },
                    { headerText: "Comments", key: "COMMENTS", dataType: "string", width: "200px" }
                ],
            features: [
                {
                    name: 'Paging'
                },
                {
                    name: 'Sorting'
                },
                {
                    name: "RowSelectors",
                    enableCheckBoxes: true,
                    enableRowNumbering: false
                },
                {
                    name: "Selection",
                    multipleSelection: true
                },
                {
                    name: 'Updating',
                    enableAddRow: false,
                    enableDeleteRow: false,
                    editMode: "row",
                    editRowStarting: function (evt, ui) {
                        var row = ui.owner.grid.findRecordByKey(ui.rowID);
                        if (row.MSID == "(N/A)") {
                            return false;
                        }
                        else {
                            return false;
                        }
                    },
                    columnSettings:
                        [
                            { columnKey: "MSID", readOnly: true },
                            { columnKey: "ETA", readOnly: true },
                            { columnKey: "REJECTED", readOnly: true },
                            { columnKey: "isOpenInCMS", readOnly: true },
                            { columnKey: "PONUM", readOnly: true },
                            { columnKey: "MSID", readOnly: true },
                            { columnKey: "ZXPPONUM", readOnly: true },
                            { columnKey: "PRODCOUNT", readOnly: true },
                            { columnKey: "ZXPPONUM", readOnly: true },
                            { columnKey: "PRODID", readOnly: true },
                            { columnKey: "DROP", readOnly: true },
                            { columnKey: "TRUCKTYPE", readOnly: true },
                            { columnKey: "STATIDTEXT", readOnly: true },
                            { columnKey: "LOCATION", readOnly: true },
                            { columnKey: "COMMENTS", readOnly: true }

                        ]
                }
            ]

        }); <%--end of $("#truckcleanup").igGrid({--%>
    }


    function onSuccess_GetGridData(value, ctx, methodName) {
        var gridData = [];
        for (i = 0; i < value.length; i++) {
            var isOpenInCMS;
            isOpenInCMS = formatBoolAsYesOrNO(value[i][8]);
            var prodCount = value[i][9];
            var prodDetail = prodCount < 2 ? value[i][11] : "multiple";
            var prodID = prodCount < 2 ? value[i][10] : "multiple";
            gridData[i] = {
                "MSID": value[i][0], "ETA": value[i][1], "COMMENTS": value[i][2], "PONUM": value[i][3], "DROP": value[i][4],
                "TRUCKTYPE": value[i][5],"REJECTED": value[i][6],
                "STATIDTEXT": value[i][7],
                "isOpenInCMS": isOpenInCMS, "PRODCOUNT": prodCount, "PRODID": prodID, "PRODDETAIL": prodDetail,
                "ZXPPONUM": value[i][12], "LOCATION": value[i][13]
            };
        }
        <%--Rebind Data--%>
        $("#truckcleanup").igGrid("option", "dataSource", gridData);
        $("#truckcleanup").igGrid("dataBind");
    }

    function onFail_GetGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in AdminCleanUp.aspx onFail_GetGridData");
    }
    function onSuccess_CloseOutTruckSchedules(value, ctx, methodName) {
        
        alert("Done");
        PageMethods.GetGridData(onSuccess_GetGridData, onFail_GetGridData);
    }
    function onFail_CloseOutTruckSchedules(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_CleanUp.aspx onFail_CloseOutTruckSchedules");
    }

    function closeOutTrucks() {
        var selectedMSIDs = [];
        var selectedRows = $("#truckcleanup").igGrid("selectedRows");
        for (var i = 0, len = selectedRows.length; i < len; i++) {
            selectedMSIDs.push(selectedRows[i]["id"]);
        }
        if (selectedRows.length > 0) {
            PageMethods.CloseOutTruckSchedules(selectedMSIDs, onSuccess_CloseOutTruckSchedules, onFail_CloseOutTruckSchedules);
        }
        //get msid of selected


    }


    
    $(function () {
        initGrid();
        $("#btnCloseOut").click(closeOutTrucks);
        PageMethods.GetGridData(onSuccess_GetGridData, onFail_GetGridData);
    });



</script>
    <input id="btnCloseOut" class ="btn-reg" type="button" value="Close Out Selected Trucks "/> <br />
    <table id="truckcleanup" class="scrollGridClass" ></table>
    <br /><br /><br />
    <br /><br /><br />
</asp:Content>
