<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Tanks.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_Tanks1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Tanks</h2>
    <h3>View, add, update, and delete tanks. </h3>

     <script type="text/javascript">
         var GLOBAL_PRODUCT_OPTIONS = [];
         var GLOBAL_GRID_DATA = [];
         var GLOBAL_TANKID = 0;
         var GLOBAL_DELETE_DECISION = null;
         var GLOBAL_ROWID = 0;
         var GLOBAL_TANKNAME = null; <%--Used for dialog box for when a user is trying to delete--%>
         var GLOBAL_CAPACITY = 0; <%--Used for dialog box for when a user is trying to delete--%>
         var FILTERTEXTID = "";
         var FILTERTEXTNAME = "";
         var FILTERTEXT = "";
         var GLOBAL_GRID_DATA_PRODUCTS = [];
         var GLOBAL_PRODUCT_NAME_OPTIONS = [];
         var GLOBAL_PRODUCT_ID_OPTIONS = [];
         var GLOBAL_GRID_EXIST = false;
         var GLOBAL_INCOMING_SHIPMENTS = [];
         var GLOBAL_CELL_TEMPLATE = null;
         GLOBAL_CELL_TEMPLATE =
         "{{if (${CURRENTVOL}  >= ${YellowCapPercentage}) && (${CURRENTVOL} < ${OrangeCapPercentage} ) }} " +
         "<div class=\"yellowCell\"> . </div> " +
         "{{elseif (${CURRENTVOL} >= ${OrangeCapPercentage}) && (${CURRENTVOL} < ${RedCapPercentage} ) }} " +
         "<div class=\"orangeCell\"> . </div> " +
         "{{elseif (${CURRENTVOL} >= ${RedCapPercentage})}} " +
         "<div class=\"redCell\"> . </div> " +
         "{{else}} " +
         "<div></div>" +
         "{{/if}}";
        <%-------------------------------------------------------
        Pagemethods Handlers
        -----------------------------------------------------------%>

         function onSuccess_GetTanksGridData(value, ctx, methodName) {
             GLOBAL_GRID_DATA = [];
             var productOptionsIndex = 0
             if (value != null) {
                 for (i = 0; i < value.length; i++) {
                     GLOBAL_GRID_DATA[i] = {
                         "TANKID": value[i][0], "TANKNAME": value[i][1], "CAPACITY": value[i][2], "CURRENTVOL": value[i][3],
                         "YellowCapPercentage": value[i][4], "OrangeCapPercentage": value[i][5], "RedCapPercentage": value[i][6]
                     };
                 }
             }
            <%--After dropdown box data are  retrieved and set to global vars, initialize grid --%>
             if (GLOBAL_GRID_EXIST == true){
                 $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA);
                 $("#grid").igGrid("commit");
             }
             initGrid();
         }
         function onFail_GetTanksGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_GetTanksGridData");
         }

         function onSuccess_disableTank(value, ctx, methodName) {
             var tankID = $("#grid").data("data-TankID");
             $("#grid").igGridUpdating("deleteRow", tankID);
             $("#grid").igGrid("commit");
             $("#grid").data("data-TankID", 0);
         }
         function onFail_disableTank(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_disableTank");
         }
         
         function onSuccess_setNewTank(newTankID, ctx, methodName) {
             $("#grid").igGridUpdating("setCellValue", GLOBAL_TANKID, 'TANKID', newTankID);
             $("#grid").igGrid("commit");

             PageMethods.UpdateFillPercentageAlert(newTankID, onSuccess_UpdateFillPercentageAlert, onFail_UpdateFillPercentageAlert, newTankID);
         }
         function onFail_setNewTank(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_setNewTank");
         }


         function onSuccess_updateTank(value, TankID, methodName) {
             $("#grid").igGrid("commit");
             PageMethods.UpdateFillPercentageAlert(TankID, onSuccess_UpdateFillPercentageAlert, onFail_UpdateFillPercentageAlert, TankID);
             
         }
         function onFail_updateTank(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_updateTank");
         }

         
         function onSuccess_UpdateFillPercentageAlert(tankIDAndPercentageValues, tankID, methodName) {
             $("#grid").igGridUpdating("setCellValue", tankID, 'YellowCapPercentage', tankIDAndPercentageValues[0]);
             $("#grid").igGridUpdating("setCellValue", tankID, 'OrangeCapPercentage', tankIDAndPercentageValues[1]);
             $("#grid").igGridUpdating("setCellValue", tankID, 'RedCapPercentage', tankIDAndPercentageValues[2]);
             $("#grid").igGrid("commit");
         }
         function onFail_UpdateFillPercentageAlert(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_UpdateFillPercentageAlert");
         }

         function onSuccess_preTankDisabledCheck_IncomingOrderBasedOnProducts(returnValue, tankID, methodName) {
             if (checkNullOrUndefined(returnValue) == false) {
                 GLOBAL_INCOMING_SHIPMENTS = returnValue;
             }
             PageMethods.preTankDisabledCheck_Alert(tankID, onSuccess_preTankDisabledCheck_Alert, onFail_preTankDisabledCheck_Alert, tankID);
         }
         function onFail_preTankDisabledCheck_IncomingOrderBasedOnProducts(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_preTankDisabledCheck_IncomingOrderBasedOnProducts");
         }


         function onSuccess_preTankDisabledCheck_Alert(returnValue, rowID, methodName) {
                 <%--clears Div incase this is not the first table render--%>
             $("#tblIncomingShipments").empty();


                 <%-- gets div--%>
                 var logDiv = document.getElementById("tblIncomingShipments");
                 <%-- creates table and table body and sets attributes for table--%>
             var tbl = document.createElement('table');
             var lblMessage = document.createElement("Label");
             lblMessage.innerHTML = "<b>Deleting this tank will affect the following. This action can not be undone. Would you like to continue deleting?</b> <br/><br/>";
             logDiv.appendChild(lblMessage);

                 if (GLOBAL_INCOMING_SHIPMENTS.length > 0) {
                     tbl.style.width = '100%';
                     tbl.setAttribute('border', '1');
                     var tblBody = document.createElement("tbody");
                     var lblIncomingOrders = document.createElement("Label");
                     lblIncomingOrders.innerHTML = "<br/><b>Possible Affected Upcoming Orders</b>";
                     var header = tbl.createTHead();
                     var row = header.insertRow(0);
                     var cell = row.insertCell(0);
                     cell.innerHTML = "<b>Product</b>";
                     var cell2 = row.insertCell(1);
                     cell2.innerHTML = "<b>Expected in X Amount of Orders</b>";

                     for (var i = 0; i < GLOBAL_INCOMING_SHIPMENTS.length; i++) {
                         var prodNameID = GLOBAL_INCOMING_SHIPMENTS[i][0] + " - " + GLOBAL_INCOMING_SHIPMENTS[i][1];
                         <%-- creates row and both cells (one for event time and another for event details--%>
                         var row = document.createElement('tr');
                         var cellProdNameID = document.createElement("td");
                         var cellExpectedInXOrders = document.createElement("td");

                         <%--sets cell text--%>
                         var cellProdNameIDText = document.createTextNode(prodNameID);
                         var cellExpectedInXOrdersText = document.createTextNode(GLOBAL_INCOMING_SHIPMENTS[i][2]);

                         <%-- sets cell text to each cell & append cell to row--%>
                         cellProdNameID.appendChild(cellProdNameIDText);
                         row.appendChild(cellProdNameID);

                         cellExpectedInXOrders.appendChild(cellExpectedInXOrdersText);
                         row.appendChild(cellExpectedInXOrders);

                         <%-- appends row to table body--%>
                         tblBody.appendChild(row);
                     }
                     <%-- appends table body to table--%>
                     tbl.appendChild(tblBody);
                     logDiv.appendChild(lblIncomingOrders);
                 <%--appends table to log div--%>
                     logDiv.appendChild(tbl);

                 }
             
             <%-- creates table and table body and sets attributes for table--%>
             var tbl2 = document.createElement('table');




             if (returnValue.length > 0) {
                 tbl2.style.width = '100%';
                 tbl2.setAttribute('border', '1');
                 var tblBody2 = document.createElement("tbody");
                 var lblAlerts = document.createElement("Label");
                 lblAlerts.innerHTML = "<br/><b>Alerts Affected</b>";
                 var header2 = tbl2.createTHead();
                 var row2 = header2.insertRow(0);
                 var cell3 = row2.insertCell(0);
                 cell3.innerHTML = "<b>Alert Name</b>";
                 var cell4 = row2.insertCell(1);
                 cell4.innerHTML = "<b>Capacity Perentage</b>";

                 for (var i = 0; i < returnValue.length; i++) {
                     var alertName = returnValue[i][0];
                     var capacityPercentage = returnValue[i][1] + "%";

                     <%-- creates row and both cells (one for event time and another for event details--%>
                     var row2 = document.createElement('tr');
                     var cellAlertName = document.createElement("td");
                     var cellCapacityPercentage = document.createElement("td");

                     <%--sets cell text--%>
                     var cellAlertNameText = document.createTextNode(alertName);
                     var cellCapacityPercentageText = document.createTextNode(capacityPercentage);

                     <%-- sets cell text to each cell & append cell to row--%>
                     cellAlertName.appendChild(cellAlertNameText);
                     row2.appendChild(cellAlertName);

                     cellCapacityPercentage.appendChild(cellCapacityPercentageText);
                     row2.appendChild(cellCapacityPercentage);


                     <%-- appends row to table body--%>
                     tblBody2.appendChild(row2);
                 }
                 <%-- appends table body to table--%>
                 tbl2.appendChild(tblBody2);
                 logDiv.appendChild(lblAlerts);
                 <%--appends table to log div--%>
                 logDiv.appendChild(tbl2);
             }
             
             if (returnValue.length > 0 || GLOBAL_INCOMING_SHIPMENTS.length > 0) {
                 <%--appends table to log div     logDiv.appendChild(tbl);--%>
                 $("#deleteConfirmationDialogBox").igDialog("open");
             }
             else {
                 var tankID = $("#grid").data("data-TankID");
                 var tankName = $("#grid").igGrid("getCellValue", tankID, "TANKNAME");
                 var r = confirm("You are about to delete " + tankName + ". This can not be undone. Would you still like to continue deleting " + tankName + "?");
                 if (r === true) {
                     PageMethods.disableTank(tankID, onSuccess_disableTank, onFail_disableTank, tankID);
                 }
             }
         }
         function onFail_preTankDisabledCheck_Alert(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Tanks.aspx, onFail_preTankDisabledCheck_Alert");
         }


         <%-------------------------------------------------------
        Format & other methods
        -----------------------------------------------------------%>
         function searchArray(nameKey, myArray) {
             if (myArray.length == 0) {
                 return false;
             }
             else {
                 for (var i = 0; i < myArray.length; i++) {
                     if (myArray[i].PRODUCT == nameKey) {
                         return true;
                     }
                 }
                 return false;
             }
         }

 <%-------------------------------------------------------
        Initialize Infragistics IgniteUI Controls
        -------------------------------------------------------%>
         
         $(function () {
             $(".arrowGridScrollButtons").show();
             PageMethods.GetTanksGridData(onSuccess_GetTanksGridData, onFail_GetTanksGridData);
             $("#deleteConfirmationDialogBox").igDialog({
                 width: "750px",
                 height: "500px",
                 state: "closed",
                 closeOnEscape: false,
                 showCloseButton: false,
                 stateChanging: function (evt, ui) {
                     if (ui.action === "close") {
                         if (GLOBAL_DELETEDECISION == true) {
                             var tankID = $("#grid").data("data-TankID");
                             PageMethods.disableTank(tankID, onSuccess_disableTank, onFail_disableTank, tankID);
                         }
                     }
                     else if (ui.action === "open") {
                     }
                 }

             }); //end of $("#deleteConfirmationDialogBox").igDialog({
         });

        function initGrid() {
            $("#grid").igGrid({
                dataSource: GLOBAL_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: true,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "TANKID",
                columns:
                    [
                        { headerText: " ", key: "FULLNESSCOLOREDALERT", width: "20px", template: GLOBAL_CELL_TEMPLATE },
                        { headerText: "", key: "TANKID", dataType: "number", hidden: true ,width:"0px"},
                        { headerText: "Tank Name", key: "TANKNAME", dataType: "string" , width:"800px" },
                        { headerText: "Max Capacity (Gallons)", key: "CAPACITY", dataType: "number", width:"100px"},
                        { headerText: "Current Capacity (Gallons)", key: "CURRENTVOL", dataType: "number", width: "100px" },
                        { headerText: "", key: "YellowCapPercentage", dataType: "number", hidden: true, width: "0px" },
                        { headerText: "", key: "OrangeCapPercentage", dataType: "number", hidden: true, width: "0px" },
                        { headerText: "", key: "RedCapPercentage", dataType: "number", hidden: true, width: "0px" }
                    ],
                features: [
                    {
                        name: 'Paging'
                    },
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
                    },
                    {
                        name: 'Updating',
                        enableAddRow: true,
                        editMode: 'row',
                        enableDeleteRow: true,
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        autoCommit: false,
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            var isValidName = true;
                            GLOBAL_TANKID = 0;
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                                GLOBAL_TANKID = ui.values.TANKID;
                                for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                    if (ui.values.TANKNAME.toLowerCase() === GLOBAL_GRID_DATA[i].TANKNAME.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA[i].TANKID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("There is another tank named " + ui.values.TANKNAME + ". Please rename and try again.");
                                            isValidName = false;
                                        }
                                    }
                                }
                                if (isValidName === true) {
                                    ui.values.YellowCapPercentage = 0;
                                    ui.values.OrangeCapPercentage = 0;
                                    ui.values.RedCapPercentage = 0;
                                    if (ui.values.CAPACITY <= 0) {
                                        alert("Max capacity can not be 0.")
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else if (ui.values.CAPACITY < ui.values.CURRENTVOL) {
                                        alert("Current capacity can not be a greater volume than the max capcity.")
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else if (ui.values.CURRENTVOL < 0) {
                                        alert("Current capacity can not be less than 0.")
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else {
                                        PageMethods.setNewTank(ui.values.TANKNAME, ui.values.CAPACITY, ui.values.CURRENTVOL, onSuccess_setNewTank, onFail_setNewTank);
                                    }
                                }
                            }
                            // else if (ui.update == true && ui.rowAdding == false && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                           else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                                for (var i = 0; i < GLOBAL_GRID_DATA.length; i++) {
                                    if (ui.values.TANKNAME.toLowerCase() === GLOBAL_GRID_DATA[i].TANKNAME.toLowerCase()) {
                                        if (GLOBAL_GRID_DATA[i].TANKID != ui.rowID) {
                                            ui.keepEditing = true;
                                            alert("There is another tank named " + ui.values.TANKNAME + ". Please rename and try again.");
                                            isValidName = false;
                                            ui.keepEditing = true;
                                            return false;
                                        }
                                    }
                                }
                                if (isValidName === true) {
                                    ui.values.YellowCapPercentage = 0;
                                    ui.values.OrangeCapPercentage = 0;
                                    ui.values.RedCapPercentage = 0;
                                    GLOBAL_CORRECTED_PERCENTAGE = formatterPercentageUpdate(ui.values.CAPACITY);
                                    if (ui.values.CAPACITY <= 0) {
                                        alert("Max capacity can not be 0.");
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else if (ui.values.CAPACITY < ui.values.CURRENTVOL) {
                                        alert("Current capacity can not be a greater volume than the max capcity.");
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else if (ui.values.CURRENTVOL < 0) {
                                        alert("Current capacity can not be less than 0.");
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    else {
                                        PageMethods.updateTank(ui.rowID, ui.values.TANKNAME, ui.values.CAPACITY, ui.values.CURRENTVOL, onSuccess_updateTank, onFail_updateTank, ui.rowID);
                                    }
                                }
                            }
                            else {
                                return false;
                            }
                        },
                        rowDeleting: function (evt, ui) {
                            $("#grid").data("data-TankID", ui.rowID);
                            PageMethods.preTankDisabledCheck_IncomingOrderBasedOnProducts(ui.rowID, onSuccess_preTankDisabledCheck_IncomingOrderBasedOnProducts, onFail_preTankDisabledCheck_IncomingOrderBasedOnProducts, ui.rowID);
                            return false;
                        },
                        columnSettings: 
                            [
                                { columnKey: "FULLNESSCOLOREDALERT", readOnly: true},
                                //{ columnKey: "CURRENTVOL", readOnly: true, required: true },
                                { columnKey: "TANKID", readOnly: false, required: true },
                                { columnKey: "TANKNAME", readOnly: false, required: true },
                                {
                                    columnKey: "CURRENTVOL",
                                    required: true,
                                    editorOptions: {
                                        minValue: 0,
                                        maxDecimals: 5,
                                        minDecimals: 5
                                    }
                                },
                                {
                                    columnKey: "CAPACITY",
                                    required: true,
                                    editorOptions: {
                                        minValue: 0,
                                        maxDecimals: 5,
                                        minDecimals: 5
                                    }
                                }
                            ]
                    }

                ]

            }); <%--end of $("#grid").igGrid({--%>
            GLOBAL_GRID_EXIST = true;
            $("#gridProducts").hide();
            $("#button_BackToTanks").hide();
         }

         
    </script>
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>

    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
        <br />
        <br />
   <div id="gridWrapper"><table id="grid" class="scrollGridClass"></table></div>
    <button type="button" id="button_BackToTanks" onclick='onClick_BackToTanks()'>Back To Tanks</button>
    <div id ="deleteConfirmationDialogBox">
        
            <div id="tblIncomingShipments">
            </div>

        <br />
            <div class="tblAlerts">
            </div>
        <button type="button" id="keepUserButton" onclick='GLOBAL_DELETEDECISION = false; $("#deleteConfirmationDialogBox").igDialog("close")'>No</button>
        <button type="button" id="disableUserButton" onclick='GLOBAL_DELETEDECISION = true; $("#deleteConfirmationDialogBox").igDialog("close")'>Yes</button>
    </div>

</asp:Content>