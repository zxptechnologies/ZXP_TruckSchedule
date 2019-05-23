<%@ Page Title="" Language="C#" MasterPageFile="~/AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_UserAlerts.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_UserAlerts" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
       
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

     <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
         var GLOBAL_DEMURRAGE_GRID_DATA = [];
         var GLOBAL_CAPACITY_GRID_DATA = [];
         var GLOBAL_INACTIVE_GRID_DATA = [];
         var GLOBAL_USER_ALERTS = [];
         var data = [];
         var GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA = [];
         var GLOBAL_DROP_TRAILER_GRID_DATA = [];
         var GLOBAL_COFA_UPLOAD_GRID_DATA = [];
         var GLOBAL_CURRENT_GRID;
         var GLOBAL_SAVE_BTN_FLAG = false;
         var GLOBAL_SMS_ALERTFLAG = false
         var GLOBAL_EVENT_GRID_DATA = [];
         var GLOBAL_DEMURRAGE_TIME_IN_MINS = 0;
         var GLOBAL_DEMURRAGE_TIME_OPTIONS = [];

         <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

         function onSuccess_getDemurrageTimeInMins(demurrageTime, ctx, methodName) {
             if (!checkNullOrUndefined(demurrageTime)) {
                 GLOBAL_DEMURRAGE_TIME_IN_MINS = demurrageTime;
             }
             PageMethods.getDemurrageTimeOptions(onSuccess_getDemurrageTimeOptions, onFail_getDemurrageTimeOptions);
         }
         function onFail_getDemurrageTimeInMins(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getDemurrageTimeInMins");
         }

         function onSuccess_getDemurrageTimeOptions(demurrageComboBoxOptions, ctx, methodName) {
             if (demurrageComboBoxOptions.length > 0) {
                 for (var i = 0; i < demurrageComboBoxOptions.length; i++) {
                     //var demurrageOptionValue = Number((demurrageComboBoxOptions[i].Key + 0));
                     GLOBAL_DEMURRAGE_TIME_OPTIONS.push({ "dOptionLabel": demurrageComboBoxOptions[i].Value, "dOptionValue": demurrageComboBoxOptions[i].Key });
                 }
             }
             PageMethods.getDemurrageAlertsGridData(onSuccess_getDemurrageAlertsGridData, onFail_getDemurrageAlertsGridData);
         }
         function onFail_getDemurrageTimeOptions(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getDemurrageTimeOptions");
         }
         function onSuccess_getCapacityAlertsGridData(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     GLOBAL_CAPACITY_GRID_DATA[i] = {
                         "ALERTID": value[i][0], "NAME": value[i][1], "TANK": value[i][2], "PERCENT": value[i][3], "EMAIL": value[i][4], "SMS": value[i][5], "ALERTUSERID": 0
                     }
                 }
             }
             PageMethods.getInactiveAlertsGridData(onSuccess_getInactiveAlertsGridData, onFail_getInactiveAlertsGridData);
         }
         function onFail_getCapacityAlertsGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getCapacityAlertsGridData");
         }


         function onSuccess_getDemurrageAlertsGridData(value, ctx, methodName) {
             GLOBAL_DEMURRAGE_GRID_DATA = [];
             var productOptionsIndex = 0;
             var productNameNum = null;
             var checkIfProductExsitsInOptions;
             var newTimeString;
             var positiveOrNegative;
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {

                     if(value[i][2] < 0)
                     {
                         positiveOrNegative = '-';
                         newTimeString = convertMinsToTimeString((value[i][2]*-1));
                     }
                     else{
                         positiveOrNegative = '+';
                         newTimeString = convertMinsToTimeString(value[i][2]);
                     }

                     GLOBAL_DEMURRAGE_GRID_DATA[i] = {
                         "ALERTID": value[i][0], "NAME": value[i][1], "TIME": newTimeString,
                         "EMAIL": value[i][3], "SMS": value[i][4], "PRODUCT": value[i][5], "ALERTUSERID": 0, "TIMEOPTION": positiveOrNegative
                     }
                 }
             }
             PageMethods.getCapacityAlertsGridData(onSuccess_getCapacityAlertsGridData, onFail_getCapacityAlertsGridData);
         }
         function onFail_getDemurrageAlertsGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getDemurrageAlertsGridData");
         }


         function onSuccess_getInactiveAlertsGridData(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     GLOBAL_INACTIVE_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "TIME": value[i][2], "EMAIL": value[i][3], "SMS": value[i][4], "ALERTUSERID": 0 }
                 }
             }
             PageMethods.getInspectionDealBreakerGridData(onSuccess_getInspectionDealBreakerGridData, onFail_getInspectionDealBreakerGridData);
         }
         function onFail_getInactiveAlertsGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getInactiveAlertsGridData");
         }

         function onSuccess_getInspectionDealBreakerGridData(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "INSPECTIONNAME": value[i][2], "HEADERID": value[i][3], "EMAIL": value[i][4], "SMS": value[i][5], "ALERTUSERID": 0 }
                 }
             }
             PageMethods.getDropTrailerGridData(onSuccess_getDropTrailerGridData, onFail_getDropTrailerGridData);
         }
         function onFail_getInspectionDealBreakerGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getInspectionDealBreakerGridData");
         }

         function onSuccess_getDropTrailerGridData(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     GLOBAL_DROP_TRAILER_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "PRODUCT": value[i][2], "DAYS": value[i][3], "EMAIL": value[i][4], "SMS": value[i][5], "ALERTUSERID": 0 }
                 }
             }
             PageMethods.getCOFAUploadGridData(onSuccess_getCOFAUploadGridData, onFail_getCOFAUploadGridData);
         }
         function onFail_getDropTrailerGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getDropTrailerGridData");
         }

         function onSuccess_getCOFAUploadGridData(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     GLOBAL_COFA_UPLOAD_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "TIME": value[i][2], "EMAIL": value[i][3], "SMS": value[i][4], "ALERTUSERID": 0 }
                 }
             }
             PageMethods.getEventGridData(onSuccess_getEventGridData, onFail_getEventGridData);
         }
         function onFail_getCOFAUploadGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getCOFAUploadGridData");
         }

         function onSuccess_getEventGridData(value, ctx, methodName) {
             var tempProduct = "ALL";
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     if (!checkNullOrUndefined(value[i][2])) {
                         tempProduct = value[i][2].trim() + " - " + value[i][6].trim();
                     }
                     else {
                         tempProduct = "ALL - All Products";
                     }

                     GLOBAL_EVENT_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "PRODUCT": tempProduct, "EMAIL": value[i][3], "SMS": value[i][4], "EVENT": value[i][5] }
                 }
             }
             init();
         }
         function onFail_getEventGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getEventGridData");
         }
         function onSuccess_getUserAlerts(value, ctx, methodName) {
             GLOBAL_USER_ALERTS = [];
             GLOBAL_USER_ALERTS = value;
             for (i = 0; i < value.length; i++) {
                 switch (value[i][0]) {
                     case 1:
                         $("#demurrageGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#demurrageGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#demurrageGrid").igGrid("commit");
                         break;
                     case 2:
                         $("#capacityGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#capacityGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#capacityGrid").igGrid("commit");
                         break;
                     case 3:
                         $("#inactiveGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#inactiveGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#inactiveGrid").igGrid("commit");
                         break;
                     case 4:
                         $("#inspectionDealBreakerGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#inspectionDealBreakerGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#inspectionDealBreakerGrid").igGrid("commit");
                         break;
                     case 5:
                         $("#dropTrailerGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#dropTrailerGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#dropTrailerGrid").igGrid("commit");
                         break;
                     case 6:
                         $("#COFAUploadGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#COFAUploadGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#COFAUploadGrid").igGrid("commit");
                         break;
                     case 1007:
                         $("#eventGrid").igGridUpdating("setCellValue", value[i][1], "USERALERT", true);
                         $("#eventGrid").igGridUpdating("setCellValue", value[i][1], "ALERTUSERID", value[i][2]);
                         $("#eventGrid").igGrid("commit");
                         break;
                 }
             }
         }
         function onFail_getUserAlerts(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_getUserAlerts");
         }


         function onSuccess_disableUserAlert(value, ctx, methodName) {
             var gridIdentifier = "#" + GLOBAL_CURRENT_GRID;
             $(gridIdentifier).igGridUpdating("setCellValue", ctx, "ALERTUSERID", 0);
             $(gridIdentifier).igGrid("commit");
             GLOBAL_CURRENT_GRID = null;
         }
         function onFail_disableUserAlert(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_disableUserAlert");
         }


         function onSuccess_setNewUserAlert(value, ctx, methodName) {
             var gridIdentifier = "#" + GLOBAL_CURRENT_GRID;
             $(gridIdentifier).igGridUpdating("setCellValue", ctx, "ALERTUSERID", value);
             $(gridIdentifier).igGrid("commit"); onSuccess_setNewUserAlert
             GLOBAL_CURRENT_GRID = null;
         }
         function onFail_setNewUserAlert(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_setNewUserAlert");
         }


         function onSuccess_setNewUserAlert(value, ctx, methodName) {
             var gridIdentifier = "#" + GLOBAL_CURRENT_GRID;
             $(gridIdentifier).igGridUpdating("setCellValue", ctx, "ALERTUSERID", value);
             $(gridIdentifier).igGrid("commit");
             GLOBAL_CURRENT_GRID = null;
         }
         function onFail_setNewUserAlert(value, ctx, methodName) {
             sendtoErrorPage("Error in Admin_UserAlerts.aspx, onFail_setNewUserAlert");
         }


         function onclick_ShowDemurrage() {
             $("#demurrageGridWrapper").show();
             $("#btn_ShowDemurrage").hide();
             $("#btn_HideDemurrage").show();
         }
         function onclick_HideDemurrage() {
             $("#demurrageGridWrapper").hide();
             $("#btn_ShowDemurrage").show();
             $("#btn_HideDemurrage").hide();
         }

         function onclick_ShowCapacity() {
             $("#capacityGridWrapper").show();
             $("#btn_ShowCapacity").hide();
             $("#btn_HideCapacity").show();
         }
         function onclick_HideCapacity() {
             $("#capacityGridWrapper").hide();
             $("#btn_ShowCapacity").show();
             $("#btn_HideCapacity").hide();
         }

         function onclick_ShowInactive() {
             $("#inactiveGridWrapper").show();
             $("#btn_ShowInactive").hide();
             $("#btn_HideInactive").show();
         }
         function onclick_HideInactive() {
             $("#inactiveGridWrapper").hide();
             $("#btn_ShowInactive").show();
             $("#btn_HideInactive").hide();
         }

         function onclick_ShowDealBreaker() {
             $("#inspectionDealBreakerGridWrapper").show();
             $("#btn_ShowDealBreaker").hide();
             $("#btn_HideDealBreaker").show();
         }
         function onclick_HideDealBreaker() {
             $("#inspectionDealBreakerGridWrapper").hide();
             $("#btn_ShowDealBreaker").show();
             $("#btn_HideDealBreaker").hide();
         }

         function onclick_ShowDropTrailer() {
             $("#dropTrailerGridWrapper").show();
             $("#btn_ShowDropTrailer").hide();
             $("#btn_HideDropTrailer").show();
         }
         function onclick_HideDropTrailer() {
             $("#dropTrailerGridWrapper").hide();
             $("#btn_ShowDropTrailer").show();
             $("#btn_HideDropTrailer").hide();
         }

         function onclick_ShowCOFAUpload() {
             $("#COFAUploadGridWrapper").show();
             $("#btn_ShowCOFAUpload").hide();
             $("#btn_HideCOFAUpload").show();
         }
         function onclick_HideCOFAUpload() {
             $("#COFAUploadGridWrapper").hide();
             $("#btn_ShowCOFAUpload").show();
             $("#btn_HideCOFAUpload").hide();
         }

         function onclick_ShowEvent() {
             $("EventGridWrapper").show();
             $("#btn_ShowEvent").hide();
             $("#btn_HideEvent").show();
         }
         function onclick_HideEvent() {
             $("#EventGridWrapper").hide();
             $("#btn_ShowEvent").show();
             $("#btn_HideEvent").hide();
         }
         function formatDemurrageTimeOptions(val) {
             var i, option;
             for (i = 0; i < GLOBAL_DEMURRAGE_TIME_OPTIONS.length; i++) {
                 option = GLOBAL_DEMURRAGE_TIME_OPTIONS[i];
                 if (option.dOptionValue == val) {
                     val = option.dOptionLabel;
                 }
             }
             return val;
         }


         function convertMinsToTimeString(mins) {
             var newTimeString = "00:00";
             if (mins >= 60) { //time is in minutes. need to covert to HH:MM format
                 newTimeString = mins / 60;

                 var hours = Math.floor(mins / 60);
                 var minutes = mins % 60;

                 if (minutes < 10) {
                     minutes = "0" + minutes.toString();
                 }

                 if (hours < 10) {
                     hours = "0" + hours.toString();
                 }

                 newTimeString = hours.toString() + ":" + minutes.toString();

             }
             else {
                 newTimeString = "00:" + mins.toString();
             }
             return newTimeString;
         }




         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
         function init() {
             var demurrageHeaderTextForOptions = "Before or after demurrage countdown has ended. Demurrage last " + GLOBAL_DEMURRAGE_TIME_IN_MINS + " minutes ";

             $("#demurrageGrid").igGrid({
                 dataSource: GLOBAL_DEMURRAGE_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "ALERTID",
                 columns: [
                     { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                     { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                     { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                     //{ headerText: "Product", key: "PRODUCT", dataType: "string", width: "250px" },
                    { headerText: demurrageHeaderTextForOptions, key: "TIMEOPTION", formatter: formatDemurrageTimeOptions, dataType: "string", width: "500px" },
                     { headerText: "Time till Demurrage (HH:MM)", key: "TIME", dataType: "datetime", format: "HH:mm:ss", width: "250px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true, width: "0px" }
                 ],
                 features: [
                     { name: 'Paging' },
                     { name: 'Resizing' },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                     },
                     { name: 'Sorting' },
                    {
                        name: "Updating",
                        enableAddRow: false,
                        editMode: "row",
                        enableDeleteRow: false,
                        rowEditDialogContainment: "owner",
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        editRowEnded: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                $("#demurrageGrid").igGrid("rollback", ui.rowID, true);
                                return false;
                            }
                            if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                window.btn_clicked = false;
                                GLOBAL_CURRENT_GRID = "demurrageGrid";

                                var uName = sessionStorage.getItem("uName_Alerts");
                                var hasCell = sessionStorage.getItem("hasCell_Alerts");

                                if ((ui.values.SMS == true && ui.values.EMAIL == true) || (ui.values.SMS == true && ui.values.EMAIL == false && GLOBAL_SMS_ALERTFLAG == true) || (ui.values.SMS == false && ui.values.EMAIL == false) || hasCell == true) {

                                    if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                        var uID = sessionStorage.getItem("userID_Alerts");
                                        PageMethods.setNewUserAlert(uID, ui.rowID, 1, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                    }
                                    else if (ui.oldValues.USERALERT === true) {
                                        var alertUserID = $("#demurrageGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                        PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                    }


                                }
                                else if (ui.values.SMS == true && ui.values.EMAIL == true && GLOBAL_SMS_ALERTFLAG == false && hasCell == 'false') {
                                    var res = confirm(uName + " can not receivethis alert as a text message because there is not a cell phone number for him/her in the system. They will still be able to receivethis alert as an email. Would you like to contitue to add this alert to " + uName + "?");
                                    if (res == true) {
                                        GLOBAL_SMS_ALERTFLAG = true;
                                        if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                            var uID = sessionStorage.getItem("userID_Alerts");
                                            PageMethods.setNewUserAlert(uID, ui.rowID, 1, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                        }
                                        else if (ui.oldValues.USERALERT === true) {
                                            var alertUserID = $("#demurrageGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                            PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                        }
                                        GLOBAL_SMS_ALERTFLAG = true;
                                    }
                                }
                                else if (ui.values.SMS == true && ui.values.EMAIL == false && hasCell == false == 'false') {
                                    alert(uName + " could not be added to this alert becuase this alert is text message only and he/she has no cell phone provided in the system.");
                                }
                            }
                            else {
                                ui.keepEditing = true;
                                return false;
                            }

                        },
                        columnSettings: [
                        { columnKey: "NAME", readOnly: true },
                        { columnKey: "TIMEOPTION", readOnly: true },
                            { columnKey: "TIME", readOnly: true },
                            { columnKey: "PRODUCT", readOnly: true },
                            { columnKey: "EMAIL", readOnly: true },
                            { columnKey: "SMS", readOnly: true }

                        ]
                    },
                 ]
             }) <%--end $("#demurrageGrid").igGrid--%>



            $("#capacityGrid").igGrid({
                dataSource: GLOBAL_CAPACITY_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                    { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                    { headerText: "Tank Percent Full", key: "PERCENT", dataType: "number", format: "percent", width: "150px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                    { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true, width: "0px" }
                ],
                features: [
                    { name: 'Paging' },
                    { name: 'Resizing' },
                    {
                        name: "Filtering",
                        allowFiltering: true,
                        caseSensitive: false,
                    },
                    { name: 'Sorting' },
                   {
                       name: "Updating",
                       enableAddRow: false,
                       editMode: "row",
                       enableDeleteRow: false,
                       rowEditDialogContainment: "owner",
                       showReadonlyEditors: false,
                       enableDataDirtyException: false,
                       editRowEnded: function (evt, ui) {
                           var origEvent = evt.originalEvent;
                           if (typeof origEvent === "undefined") {
                               ui.keepEditing = true;
                               return false;
                           }
                           if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               $("#capacityGrid").igGrid("rollback", ui.rowID, true);
                               return false;
                           }
                           if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               window.btn_clicked = false;
                               GLOBAL_CURRENT_GRID = "capacityGrid";
                               if ((ui.values.SMS == true && ui.values.EMAIL == false) || (ui.values.SMS == true && ui.values.EMAIL == true && GLOBAL_SMS_ALERTFLAG == false)) {
                                   if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                       var uID = sessionStorage.getItem("userID_Alerts");
                                       PageMethods.setNewUserAlert(uID, ui.rowID, 2, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                   }
                                   else if (ui.oldValues.USERALERT === true) {
                                       var alertUserID = $("#capacityGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                       PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                   }
                                   if (ui.values.SMS == true && ui.values.EMAIL == true && GLOBAL_SMS_ALERTFLAG == false) {
                                       GLOBAL_SMS_ALERTFLAG = true;
                                   }
                               }
                           }
                       },
                       columnSettings: [
                           { columnKey: "NAME", readOnly: true },
                           { columnKey: "PERCENT", readOnly: true },
                           { columnKey: "EMAIL", readOnly: true },
                           { columnKey: "SMS", readOnly: true },
                           {
                               columnKey: "PERCENT", readOnly: true
                           },
                           {
                               columnKey: "EMAIL", readOnly: true
                           },
                           {
                               columnKey: "SMS", readOnly: true
                           }

                       ],
                   }
                ]
            }) <%--end $("#capacityGrid").igGrid--%>


            $("#inactiveGrid").igGrid({
                dataSource: GLOBAL_INACTIVE_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                    { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                    { headerText: "Inactive Time", key: "TIME", dataType: "string", width: "150px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                    { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true, width: "0px" },
                ],
                features: [
                    { name: 'Paging' },
                    { name: 'Resizing' },
                    {
                        name: "Filtering",
                        allowFiltering: true,
                        caseSensitive: false,
                    },
                    { name: 'Sorting' },
                   {
                       name: "Updating",
                       enableAddRow: false,
                       editMode: "row",
                       enableDeleteRow: false,
                       rowEditDialogContainment: "owner",
                       showReadonlyEditors: false,
                       enableDataDirtyException: false,
                       editRowEnded: function (evt, ui) {
                           var origEvent = evt.originalEvent;
                           if (typeof origEvent === "undefined") {
                               ui.keepEditing = true;
                               return false;
                           }
                           if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               $("#inactiveGrid").igGrid("rollback", ui.rowID, true);
                               return false;
                           }
                           if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               window.btn_clicked = false;
                               GLOBAL_CURRENT_GRID = "inactiveGrid";
                               if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                   var uID = sessionStorage.getItem("userID_Alerts");
                                   PageMethods.setNewUserAlert(uID, ui.rowID, 3, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                               }
                               else if (ui.oldValues.USERALERT === true) {
                                   var alertUserID = $("#inactiveGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                   PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                               }
                           }
                       },
                       columnSettings: [
                           { columnKey: "NAME", readOnly: true },
                           { columnKey: "TIME", readOnly: true },
                           { columnKey: "EMAIL", readOnly: true },
                           { columnKey: "SMS", readOnly: true }
                       ]
                   },
                ]
            }) <%--end $("#inactiveGrid").igGrid--%>


             $("#inspectionDealBreakerGrid").igGrid({
                 dataSource: GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "ALERTID",
                 columns: [
                     { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                     { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                     { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                     { headerText: "", key: "HEADERID", dataType: "string", hidden: true, width: "0px" },
                     { headerText: "Inspection Title Text", key: "INSPECTIONNAME", dataType: "string", width: "250px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                    { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true, width: "0px" }
                 ],
                 features: [
                     { name: 'Paging' },
                     { name: 'Resizing' },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                     },
                     { name: 'Sorting' },
                     {
                         name: "Updating",
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         rowEditDialogContainment: "owner",
                         showReadonlyEditors: false,
                         enableDataDirtyException: false,
                         editRowEnded: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 $("#inspectionDealBreakerGrid").igGrid("rollback", ui.rowID, true);
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 window.btn_clicked = false;
                                 GLOBAL_CURRENT_GRID = "inspectionDealBreakerGrid";
                                 if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                     var uID = sessionStorage.getItem("userID_Alerts");
                                     PageMethods.setNewUserAlert(uID, ui.rowID, 4, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                 }
                                 else if (ui.oldValues.USERALERT === true) {
                                     var alertUserID = $("#inspectionDealBreakerGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                     PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                 }
                             }
                         },
                         columnSettings: [
                            {
                                columnKey: "NAME", readOnly: true
                            },
                             {
                                 columnKey: "HEADERID", readOnly: true
                             },
                            {
                                columnKey: "INSPECTIONNAME", readOnly: true
                            },
                             {
                                 columnKey: "EMAIL", readOnly: true
                             },
                             {
                                 columnKey: "SMS", readOnly: true
                             }
                         ]
                     }
                 ]
             }) <%--end $("#inspectionDealBreakerGrid").igGrid--%>


             $("#dropTrailerGrid").igGrid({
                 dataSource: GLOBAL_DROP_TRAILER_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "ALERTID",
                 columns: [
                     { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                     { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                     { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                     { headerText: "Days", key: "DAYS", dataType: "number", width: "150px" },
                     { headerText: "Product", key: "PRODUCT", dataType: "string", width: "500px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                    { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true }//, hidden: true }
                 ],
                 features: [
                     { name: 'Paging' },
                     { name: 'Resizing' },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                     },
                     { name: 'Sorting' },
                     {
                         name: "Updating",
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         rowEditDialogContainment: "owner",
                         showReadonlyEditors: false,
                         enableDataDirtyException: false,
                         editRowEnded: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 $("#dropTrailerGrid").igGrid("rollback", ui.rowID, true);
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 window.btn_clicked = false;
                                 GLOBAL_CURRENT_GRID = "dropTrailerGrid";
                                 if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                     var uID = sessionStorage.getItem("userID_Alerts");
                                     PageMethods.setNewUserAlert(uID, ui.rowID, 5, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                 }
                                 else if (ui.oldValues.USERALERT === true) {
                                     var alertUserID = $("#dropTrailerGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                     PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                 }
                             }
                         },
                         columnSettings: [
                             {
                                 columnKey: "NAME",
                                 readOnly: true
                             },
                            {
                                columnKey: "DAYS",
                                readOnly: true
                            },
                             {
                                 columnKey: "PRODUCT",
                                 readOnly: true
                             },
                             {
                                 columnKey: "EMAIL", readOnly: true
                             },
                             {
                                 columnKey: "SMS", readOnly: true
                             }
                         ]
                     }
                 ]
             }) <%--end $("#dropTrailerGrid").igGrid--%>

             $("#COFAUploadGrid").igGrid({
                 dataSource: GLOBAL_COFA_UPLOAD_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "ALERTID",
                 columns: [
                     { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                     { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                     { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                     { headerText: "Alert Time (HH:MM)", key: "TIME", dataType: "datetime", format: "HH:mm", width: "150px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                    { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true, width: "0px" }//, hidden: true }
                 ],
                 features: [
                     { name: 'Paging' },
                     { name: 'Resizing' },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                     },
                     { name: 'Sorting' },
                     {
                         name: "Updating",
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         rowEditDialogContainment: "owner",
                         showReadonlyEditors: false,
                         enableDataDirtyException: false,
                         editRowEnded: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 $("#COFAUploadGrid").igGrid("rollback", ui.rowID, true);
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 window.btn_clicked = false;
                                 GLOBAL_CURRENT_GRID = "COFAUploadGrid";
                                 if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                     var uID = sessionStorage.getItem("userID_Alerts");
                                     PageMethods.setNewUserAlert(uID, ui.rowID, 6, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                 }
                                 else if (ui.oldValues.USERALERT === true) {
                                     var alertUserID = $("#COFAUploadGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                     PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                 }
                             }
                         },
                         columnSettings: [
                            {
                                columnKey: "TIME",
                                readOnly: true
                            },
                             {
                                 columnKey: "NAME",
                                 readOnly: true
                             },
                             {
                                 columnKey: "EMAIL", readOnly: true
                             },
                             {
                                 columnKey: "SMS", readOnly: true
                             }
                         ]
                     }
                 ]
             }) <%--end $("#COFAUploadGrid").igGrid--%>


             $("#eventGrid").igGrid({
                 dataSource: GLOBAL_EVENT_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 autofitLastColumn: true,
                 renderCheckboxes: true,
                 primaryKey: "ALERTID",
                 columns: [
                     { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width: "0px" },
                     { headerText: "Assign Alert", key: "USERALERT", dataType: "bool", width: "85px" },
                     { headerText: "Name", key: "NAME", dataType: "string", width: "500px" },
                     { headerText: "Event", key: "EVENT", dataType: "string", width: "500px" },
                     { headerText: "Products to Associate Alert to", key: "PRODUCT", dataType: "string", width: "500px" },
                     { headerText: "Email alert", key: "EMAIL", dataType: "boolean", width: "100px", template: "{{if (${EMAIL})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: "SMS alert", key: "SMS", dataType: "boolean", width: "100px", template: "{{if (${SMS})}} <div>YES</div> {{else}} <div>NO</div> {{/if}}" },
                     { headerText: " ", key: "ALERTUSERID", dataType: "number", hidden: true }//, hidden: true }
                 ],
                 features: [
                     { name: 'Paging' },
                     { name: 'Resizing' },
                     {
                         name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                     },
                     { name: 'Sorting' },
                     {
                         name: "Updating",
                         enableAddRow: false,
                         editMode: "row",
                         enableDeleteRow: false,
                         rowEditDialogContainment: "owner",
                         showReadonlyEditors: false,
                         enableDataDirtyException: false,
                         editRowEnded: function (evt, ui) {
                             var origEvent = evt.originalEvent;
                             if (typeof origEvent === "undefined") {
                                 ui.keepEditing = true;
                                 return false;
                             }
                             if (!((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 $("#eventGrid").igGrid("rollback", ui.rowID, true);
                                 return false;
                             }
                             if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                 window.btn_clicked = false;
                                 GLOBAL_CURRENT_GRID = "eventGrid";
                                 if (ui.oldValues.USERALERT === false || ui.oldValues.USERALERT === null) {
                                     var uID = sessionStorage.getItem("userID_Alerts");
                                     PageMethods.setNewUserAlert(uID, ui.rowID, 1007, onSuccess_setNewUserAlert, onFail_setNewUserAlert, ui.rowID);
                                 }
                                 else if (ui.oldValues.USERALERT === true) {
                                     var alertUserID = $("#eventGrid").igGrid("getCellValue", ui.rowID, "ALERTUSERID");
                                     PageMethods.disableUserAlert(alertUserID, onSuccess_disableUserAlert, onFail_disableUserAlert, ui.rowID);
                                 }
                             }
                         },
                         columnSettings: [
                            {
                                columnKey: "NAME",
                                readOnly: true
                            },
                            {
                                columnKey: "EVENT",
                                readOnly: true
                            },
                             {
                                 columnKey: "PRODUCT",
                                 readOnly: true
                             },
                             {
                                 columnKey: "EMAIL", readOnly: true
                             },
                             {
                                 columnKey: "SMS", readOnly: true
                             }
                         ]
                     }
                 ]
             }) <%--end $("#eventGrid").igGrid({--%>


            var uID = sessionStorage.getItem("userID_Alerts");
            $('#demurrageGrid').data('data-UID', uID);
            var uName = sessionStorage.getItem("uName_Alerts");
            $('#demurrageGrid').data('data-UName', uName);
            var hasCell = sessionStorage.getItem("hasCell_Alerts");
            $('#demurrageGrid').data('data-hasCell', hasCell);
            PageMethods.getUserAlerts(uID, onSuccess_getUserAlerts, onFail_getUserAlerts);

        }; <%--end of function init()--%>


         $(function () {
             $(".arrowGridScrollButtons").show();
             PageMethods.getDemurrageTimeInMins(onSuccess_getDemurrageTimeInMins, onFail_getDemurrageTimeInMins);
             $("#btn_ShowDemurrage").hide();
             $("#btn_ShowCapacity").hide();
             $("#btn_ShowInactive").hide();
             $("#btn_ShowDealBreaker").hide();
             $("#btn_ShowDropTrailer").hide();
             $("#btn_ShowCOFAUpload").hide();
             $("#btn_ShowEvent").hide();

             // PageMethods.getAlertGridsData(onSuccess_getAlertGridsData, onFail_getAlertGridsData);
         });

    </script>
    
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>


    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <h2>Check all the alerts you would like the user to receive</h2>
        <br />
        <br />
    <div id="navButtons">
        <button type="button" id="toUsersButton" onclick="location.href = 'Admin_Users.aspx'">Users</button>
        <button type="button" id="toAlertsButton" onclick="location.href = 'Admin_Alerts.aspx'">Alerts</button>
    </div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDemurrage()" value="Hide Grid" id="btn_HideDemurrage"/> <input type="button" onclick="    onclick_ShowDemurrage()" value="Show Grid" id="btn_ShowDemurrage"/></div><h2>Demurrage Grid</h2></div>
    <div id="demurrageGridWrapper"><table id="demurrageGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideCapacity()" value="Hide Grid" id="btn_HideCapacity"/> <input type="button" onclick="    onclick_ShowCapacity()" value="Show Grid" id="btn_ShowCapacity"/></div><h2>Capacity Grid</h2></div>
    <div id="capacityGridWrapper"><table id="capacityGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideInactive()" value="Hide Grid" id="btn_HideInactive"/> <input type="button" onclick="    onclick_ShowInactive()" value="Show Grid" id="btn_ShowInactive"/></div><h2>Inactive Truck Grid</h2></div>
    <div id="inactiveGridWrapper"><table id="inactiveGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDealBreaker()" value="Hide Grid" id="btn_HideDealBreaker"/> <input type="button" onclick="    onclick_ShowDealBreaker()" value="Show Grid" id="btn_ShowDealBreaker"/></div><h2>Inspection Deal Breaker Grid</h2></div>
    <div id="inspectionDealBreakerGridWrapper"><table id="inspectionDealBreakerGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDropTrailer()" value="Hide Grid" id="btn_HideDropTrailer"/> <input type="button" onclick="    onclick_ShowDropTrailer()" value="Show Grid" id="btn_ShowDropTrailer"/></div><h2>Drop Trailer Grid</h2></div>
    <div id="dropTrailerGridWrapper"><table id="dropTrailerGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideCOFAUpload()" value="Hide Grid" id="btn_HideCOFAUpload"/> <input type="button" onclick="    onclick_ShowCOFAUpload()" value="Show Grid" id="btn_ShowCOFAUpload"/></div><h2>COFA Upload Grid</h2></div>
    <div id="COFAUploadGridWrapper"><table id="COFAUploadGrid" class="scrollGridClass"></table></div>

    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideEvent()" value="Hide Grid" id="btn_HideEvent"/> <input type="button" onclick="    onclick_ShowEvent()" value="Show Grid" id="btn_ShowEvent"/></div><h2>Event Driven Alerts</h2></div>
    <div id="EventGridWrapper"><table id="eventGrid" class="scrollGridClass"></table></div>



    <%--<h2>Demurrage Grid</h2>
    <table id="demurrageGrid"></table>
    <h2>Tank Capacity Grid</h2>
    <table id="capacityGrid"></table>
    <h2>Inactive Truck Grid</h2>
    <table id="inactiveGrid"></table>--%>


</asp:Content>
