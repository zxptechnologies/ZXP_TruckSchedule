<%@ Page Title="" Language="C#" MasterPageFile="AdminPage.Master" AutoEventWireup="true" CodeBehind="Admin_Alerts.aspx.cs" Inherits="TransportationProject.AdminSubPages.Admin_Alerts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <h2>Admin: Alerts</h2>
    <h3>View, add, update, and delete alerts.</h3>
    <h3>Important information related to the alert will show up after custom email or text message</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var GLOBAL_DEMURRAGE_GRID_DATA = [];
        var GLOBAL_CAPACITY_GRID_DATA = [];
        var GLOBAL_INACTIVE_GRID_DATA = [];
        var GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA = [];
        var GLOBAL_DROP_TRAILER_GRID_DATA = [];
        var GLOBAL_COFA_UPLOAD_GRID_DATA = [];
        var GLOBAL_PRODUCT_OPTIONS = [];
        var GLOBAL_INSPECTIONS = [];
        var GLOBAL_TANK_OPTIONS = [];
        var GLOBAL_CURRENT_GRID = null;
        var GLOBAL_ROWID = 0;
        var FILTERTEXT = "";
        var GLOBAL_DEMURRAGE_TIME_IN_MINS = 0;
        var GLOBAL_DEMURRAGE_TIME_OPTIONS = [];
        var GLOBAL_EVENT_OPTIONS = [];
        var GLOBAL_HOUR_OPTIONS = [];
        var GLOBAL_EVENT_GRID_DATA = [];
        var GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS = [];
        var AlertMessageElement; <%--used to keep lengths for sms and email msgs--%>




        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>

        function onSuccess_getDemurrageTimeInMins(demurrageTime, ctx, methodName) {
            if (!checkNullOrUndefined(demurrageTime) ) {
                GLOBAL_DEMURRAGE_TIME_IN_MINS = demurrageTime;
            }
            PageMethods.getDemurrageTimeOptions(onSuccess_getDemurrageTimeOptions, onFail_getDemurrageTimeOptions);
        }
        function onFail_getDemurrageTimeInMins(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getDemurrageTimeInMins");
        }

        function onSuccess_getDemurrageTimeOptions(demurrageComboBoxOptions, ctx, methodName) {
            if (demurrageComboBoxOptions.length > 0) {
                for (var i = 0; i < demurrageComboBoxOptions.length; i++) {
                    //var demurrageOptionValue = Number((demurrageComboBoxOptions[i].Key + 0));
                    GLOBAL_DEMURRAGE_TIME_OPTIONS.push({ "dOptionLabel": demurrageComboBoxOptions[i].Value, "dOptionValue": demurrageComboBoxOptions[i].Key });
                }
            }
            PageMethods.getTankOptions(onSuccess_getTankOptions, onFail_getTankOptions);
        }
        function onFail_getDemurrageTimeOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getDemurrageTimeOptions");
        }

        function onSuccess_getProductOptions(value, ctx, methodName) {
            GLOBAL_PRODUCT_OPTIONS = [];
            GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS = [];
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    var prodNameWithID = value[i][0].trim() + " - " + value[i][1].trim();
                    GLOBAL_PRODUCT_OPTIONS[i] = { "PRODUCT": value[i][0], "PRODUCTTEXT": prodNameWithID };
                    GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS[i] = { "PRODUCT": value[i][0], "PRODUCTTEXT": prodNameWithID };
                }
            }


            GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS.unshift({ "PRODUCT": "All Products", "PRODUCTTEXT": "All Products" });

            PageMethods.getEventOptions(onSuccess_getEventOptions, onFail_getEventOptions);
        }
        function onFail_getProductOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getProductOptions");
        }

        function onSuccess_getEventOptions(value, ctx, methodName) {
            GLOBAL_EVENT_OPTIONS.length = 0;
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    GLOBAL_EVENT_OPTIONS[i] = { "EVENTTYPEID": value[i][0], "EVENTDESCRIPTION": value[i][1] };
                }
            }

            PageMethods.getDemurrageGridData(onSuccess_getDemurrageGridData, onFail_getDemurrageGridData);
        }
        function onFail_getEventOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getEventOptions");
        }
        function onSuccess_getTankOptions(value, ctx, methodName) {
            GLOBAL_TANK_OPTIONS = [];
            if (value != null) {
                for (i = 0; i < value.length; i++) {
                    GLOBAL_TANK_OPTIONS[i] = { "TANK": value[i][0], "TANKNAME": value[i][1] };
                }
            }
            PageMethods.getInspectionHeaderOptions(onSuccess_getInspectionHeaderOptions, onFail_getInspectionHeaderOptions);
           // PageMethods.getDemurrageGridData(onSuccess_getDemurrageGridData, onFail_getDemurrageGridData);
        }
        function onFail_getTankOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getTankOptions");
        }
        function setDefaultHourOptions() {
            GLOBAL_HOUR_OPTIONS = [];
            GLOBAL_HOUR_OPTIONS.push({ "label": 0, "value": 0 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 8, "value": 8 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 16, "value": 16 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 24, "value": 24 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 36, "value": 36 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 48, "value": 48 });
            GLOBAL_HOUR_OPTIONS.push({ "label": 60, "value": 60 });
            //GLOBAL_HOUR_OPTIONS.push({ "label": 0, "value": 0 });
            //0, 8, 16, 24, 36, 48, 60
        }
        function onSuccess_getInspectionHeaderOptions(inspectionOptions, ctx, methodName) {
            GLOBAL_INSPECTIONS = [];
            if (inspectionOptions != null) {
                for (i = 0; i < inspectionOptions.length; i++) {
                    GLOBAL_INSPECTIONS[i] = { "INSPECTIONHEADERID": inspectionOptions[i][0], "INSPECTIONHEADERTEXT": inspectionOptions[i][1] };
                }
            }
            PageMethods.getProductOptions(onSuccess_getProductOptions, onFail_getProductOptions);
          //  PageMethods.getInspectionHeaderOptions(onSuccess_getInspectionHeaderOptions, onFail_getInspectionHeaderOptions);
        }
        function onFail_getInspectionHeaderOptions(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getInspectionHeaderOptions");
        }

        function onSuccess_getDemurrageGridData(value, ctx, methodName) {
            //var productOptionsIndex = 0;
            //var productNameNum = null;
            var result;
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
                        "ALERTID": value[i][0], "NAME": value[i][1],
                        "EMAIL": value[i][3], "SMS": value[i][4], "TIME": newTimeString, "TIMEOPTION": positiveOrNegative,
                        "EMAILSUB": value[i][5], "EMAILBODY": value[i][6], "SMSSUB": value[i][7], "SMSBODY": value[i][8]
                    }
                }
            }
            PageMethods.getCapacityGridData(onSuccess_getCapacityGridData, onFail_getCapacityGridData);
        }
        function onFail_getDemurrageGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getDemurrageGridData");
        }

        function onSuccess_getCapacityGridData(value, ctx, methodName) {
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    GLOBAL_CAPACITY_GRID_DATA[i] = {
                        "ALERTID": value[i][0], "NAME": value[i][1], "TANK": value[i][2], "PERCENT": value[i][3], "EMAIL": value[i][4], "SMS": value[i][5],
                        "EMAILSUB": value[i][6], "EMAILBODY": value[i][7], "SMSSUB": value[i][8], "SMSBODY": value[i][9]
                    }
                }
            }
            PageMethods.getInactiveGridData(onSuccess_getInactiveGridData, onFail_getInactiveGridData);
        }
        function onFail_getCapacityGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getCapacityGridData");
        }

        function onSuccess_getInactiveGridData(value, ctx, methodName) {
            var newTimeString;
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    newTimeString = convertMinsToTimeString(value[i][2]);
                    GLOBAL_INACTIVE_GRID_DATA[i] = {
                        "ALERTID": value[i][0], "NAME": value[i][1], "TIME": newTimeString, "EMAIL": value[i][3], "SMS": value[i][4],
                        "EMAILSUB": value[i][5], "EMAILBODY": value[i][6], "SMSSUB": value[i][7], "SMSBODY": value[i][8]
                    }
                }
            }
            PageMethods.getInspectionDealBreakerGridData(onSuccess_getInspectionDealBreakerGridData, onFail_getInspectionDealBreakerGridData);
        }
        function onFail_getInactiveGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getInactiveGridData");
        }

        function onSuccess_getInspectionDealBreakerGridData(value, ctx, methodName) {
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA[i] = {
                        "ALERTID": value[i][0], "NAME": value[i][1], "HEADERID": value[i][2], "EMAIL": value[i][3], "SMS": value[i][4],
                        "EMAILSUB": value[i][5], "EMAILBODY": value[i][6], "SMSSUB": value[i][7], "SMSBODY": value[i][8]
                    }
                }
            }
            PageMethods.getDropTrailerGridData(onSuccess_getDropTrailerGridData, onFail_getDropTrailerGridData);
        }
        function onFail_getInspectionDealBreakerGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getInspectionDealBreakerGridData");
        }

        function onSuccess_getDropTrailerGridData(value, ctx, methodName) {
            var result = false;
            var needsProductRebind = false
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    var hours = convertMinsToHours(value[i][3]);
                    var mins = hours - Math.floor(hours);



                    GLOBAL_DROP_TRAILER_GRID_DATA[i] = {
                        "ALERTID": value[i][0], "NAME": value[i][1], "PRODUCT": value[i][2], "HOURS": hours, "MINS": mins, "EMAIL": value[i][4], "SMS": value[i][5],
                        "EMAILSUB": value[i][7], "EMAILBODY": value[i][8], "SMSSUB": value[i][9], "SMSBODY": value[i][10]
                    }
                    result = searchArrayForProductExistence(GLOBAL_PRODUCT_OPTIONS, value[i][6]);

                    if (result != true) {
                        var prodNameWithID = value[i][2].trim() + " - " + value[i][6].trim();
                        GLOBAL_PRODUCT_OPTIONS.push({ "PRODUCT": value[i][2], "PRODUCTTEXT": prodNameWithID });
                        needsProductRebind = true;
                    }
                }
                if (needsProductRebind === true) {
                    $("#cboxProduct").igCombo('option', 'dataSource', GLOBAL_PRODUCT_OPTIONS);
                    $("#cboxProduct").igCombo("dataBind");
                }

            }
            PageMethods.getCOFAUploadGridData(onSuccess_getCOFAUploadGridData, onFail_getCOFAUploadGridData);
        }
        function onFail_getDropTrailerGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getDropTrailerGridData");
        }

        function onSuccess_getCOFAUploadGridData(value, ctx, methodName) {
            var newTimeString;
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    newTimeString = convertMinsToTimeString(value[i][2]);
                    GLOBAL_COFA_UPLOAD_GRID_DATA[i] = {
                        "ALERTID": value[i][0], "NAME": value[i][1], "TIME": newTimeString, "EMAIL": value[i][3], "SMS": value[i][4],
                        "EMAILSUB": value[i][5], "EMAILBODY": value[i][6], "SMSSUB": value[i][7], "SMSBODY": value[i][8]
                    }
                }
            }
            PageMethods.getEventGridData(onSuccess_getEventGridData, onFail_getEventGridData);
        }
        function onFail_getCOFAUploadGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getCOFAUploadGridData");
        }

        function onSuccess_getEventGridData(value, ctx, methodName) {
            var newTimeString;
            var needsProductRebind = false;
            var result = false;
            var tempProduct = "All Products";
            if (value.length > 0) {
                for (var i = 0; i < value.length; i++) {
                    if (!checkNullOrUndefined(value[i][2])) {
                        result = searchArrayForProductExistence(GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS, value[i][6]);
                        tempProduct = value[i][2];
                    }
                    else {
                        result = true;
                        tempProduct = "All Products";
                    }


                    GLOBAL_EVENT_GRID_DATA[i] = { "ALERTID": value[i][0], "NAME": value[i][1], "PRODUCT": tempProduct, "EMAIL": value[i][3], "SMS": value[i][4], "EVENT": value[i][5], 
                        "EMAILSUB": value[i][7], "EMAILBODY": value[i][8], "SMSSUB": value[i][10], "SMSBODY": value[i][9] }

                    if (result != true) {
                        var prodNameWithID = value[i][2].trim() + " - " + value[i][6].trim();
                        GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS.push({ "PRODUCT": value[i][2], "PRODUCTTEXT": prodNameWithID });
                        needsProductRebind = true;
                    }
                }
                if (needsProductRebind === true) {
                    $("#cboxProduct").igCombo('option', 'dataSource', GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS);
                    $("#cboxProduct").igCombo("dataBind");
                }
            }
            init();
        }
        function onFail_getEventGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getEventGridData");
        }

        function onSuccess_disableAlert(value, rowID, methodName) {
            $("#" + GLOBAL_CURRENT_GRID).igGridUpdating("deleteRow", rowID);
            $("#" + GLOBAL_CURRENT_GRID).igGrid("commit");
            GLOBAL_CURRENT_GRID = "";
        }
        function onFail_disableAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_disableAlert");
        }

        function onSuccess_setNewDemurrageAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#demurrageGrid")

            $("#demurrageGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#demurrageGrid").igGrid("commit");
        }
        function onSuccess_setNewCapacityAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#capacityGrid")
            $("#capacityGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#capacityGrid").igGrid("commit");
        }
        function onSuccess_setNewInactiveAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#inactiveGrid")
            $("#inactiveGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#inactiveGrid").igGrid("commit");
        }

        function onSuccess_setNewDealBreakerAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#inspectionDealBreakerGrid")
            $("#inspectionDealBreakerGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#inspectionDealBreakerGrid").igGrid("commit");
        }
        function onSuccess_setNewDropTrailerAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#dropTrailerGrid")
            $("#dropTrailerGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#dropTrailerGrid").igGrid("commit");
        }
        function onSuccess_setNewCOFAUploadAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#COFAUploadGrid")
            $("#COFAUploadGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#COFAUploadGrid").igGrid("commit");
        }

        function onSuccess_setNewEventAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForNewAlert("#eventGrid")
            $("#eventGrid").igGridUpdating("setCellValue", ctx, 'ALERTID', value);
            $("#eventGrid").igGrid("commit");
        }
        function onFail_setNewAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_setNewAlert");
        }
        function onSuccess_updateDemurrageAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#demurrageGrid");
            $("#demurrageGrid").igGrid("commit");
        }
        function onFail_updateDemurrageAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateDemurrageAlert");
        }

        function onSuccess_updateCapacityAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#capacityGrid");
            $("#capacityGrid").igGrid("commit");
        }
        function onFail_updateCapacityAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateCapacityAlert");
        }

        function onSuccess_updateInactiveAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#inactiveGrid");
            $("#inactiveGrid").igGrid("commit");
        }
        function onFail_updateInactiveAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateInactiveAlert");
        }
        function onSuccess_updateDealBreakersAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#inspectionDealBreakerGrid");
            $("#inspectionDealBreakerGrid").igGrid("commit");
        }
        function onFail_updateDealBreakersAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateDealBreakersAlert");
        }
        function onSuccess_updateDropTrailerAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#dropTrailerGrid");
            $("#dropTrailerGrid").igGrid("commit");
        }
        function onFail_updateDropTrailerAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateDropTrailerAlert");
        }

        function onSuccess_updateCOFAUploadAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#COFAUploadGrid");
            $("#COFAUploadGrid").igGrid("commit");
        }
        function onFail_updateCOFAUploadAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateCOFAUploadAlert");
        }

        function onSuccess_updateEventAlert(value, ctx, methodName) {
            alertAboutSubAndBodyForUpdateAlert("#eventGrid");
            $("#eventGrid").igGrid("commit");
        }
        function onFail_updateEventAlert(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_updateEventAlert");
        } 

        function onSuccess_getProductListBasedOnInput_ForEventAlerts(value, grid, methodName) {
            var result = true;
            var needsRebind = false;
            if (value.length > 0) {
                for (i = 0; i < value.length; i++) {
                    result = searchArrayForProductExistence(GLOBAL_PRODUCT_OPTIONS, value[i][0]);

                    if (result != true) {
                        var prodNameWithID = value[i][1].trim() + " - " + value[i][0].trim();
                        GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodNameWithID });
                        needsRebind = true;
                    }
                }

                if (needsRebind === true) {
                    $("#cboxProduct").igCombo('option', 'dataSource', GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS);
                    $("#cboxProduct").igCombo("dataBind");
                }
                var comboEditor = $("#eventGrid").igGridUpdating("editorForKey", "PRODUCT");

                comboEditor.igCombo("text", FILTERTEXT);
            }
        }
        function onSuccess_getProductListBasedOnInput(value, grid, methodName) {
            var result = true;
            var needsRebind = false;
            if (value.length > 0) {
                for (i = 0; i < value.length; i++) {
                    result = searchArrayForProductExistence(GLOBAL_PRODUCT_OPTIONS, value[i][0]);

                    if (result != true) {
                        var prodNameWithID = value[i][1].trim() + " - " + value[i][0].trim();
                        GLOBAL_PRODUCT_OPTIONS.push({ "PRODUCT": value[i][0], "PRODUCTTEXT": prodNameWithID });
                        needsRebind = true;
                    }
                }

                if (needsRebind === true) {
                    $("#cboxProduct").igCombo('option', 'dataSource', GLOBAL_PRODUCT_OPTIONS);
                    $("#cboxProduct").igCombo("dataBind");
                }
                var comboEditor = $("#dropTrailerGrid").igGridUpdating("editorForKey", "PRODUCT");
                comboEditor.igCombo("text", FILTERTEXT);
            }
        }
        function onFail_getProductListBasedOnInput(value, ctx, methodName) {
            sendtoErrorPage("Error in Admin_Alerts.aspx, onFail_getProductListBasedOnInput");
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



        function isEmailSubjectTooLong(EmailSubject) {
            if (EmailSubject.length > AlertMessageElement.getEmailSubjectLength()){
                alert("Email Subject is too long");
                return true;
            }
            return false;
        }
        function isEmailBodyTooLong(EmailBody) {
            if (EmailBody.length > AlertMessageElement.getEmailBodyLength()) {
                alert("Email Body is too long");
                return true;
            }
            return false;
        }
        function isSMSSubjectTooLong(SMSSubject) {
            if (SMSSubject.length > AlertMessageElement.getSMSSubjectLength()) {
                alert("Text Message Subject is too long");
                return true;
            }
            return false;
        }
        function isSMSBodyTooLong(SMSBody) {
            if (SMSBody.length > AlertMessageElement.getSMSBodyLength()) {
                alert("Text Message Body is too long");
                return true;
            }
            return false;
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
                if (mins < 10) {
                    mins = "0" + mins.toString();
                }

                newTimeString = "00:" + mins.toString();
            }
            return newTimeString;
        }


        function convertTimeStringToMins(timeString) {
            var hours = 0;
            var mins = 0;
            var newTimeInMins = 0;

            if (timeString) {
                hours = timeString.slice(0, 2);
                mins = timeString.slice(3, 5);

                newTimeInMins = (Number(hours) * 60) + Number(mins);
            }
            else {
                alert("Error process time in alert");
            }

            return newTimeInMins;
        }

        function convertMinsToHours(mins) {
            return mins / 60;
        }
        function convertHoursToMins(Hours) {
            return Hours * 60;
        }
        function convertMinsToDays(mins) {
            return mins / 1440; //(1440 hours in a day)
        }
        function convertDaysToMins(days) {
            return days * 1440; //(1440 hours in a day)
        }

        
        <%-- Formatters for igGrid & other methods--%>
        function formatProducts(val) {
            var i, prod;
            for (i = 0; i < GLOBAL_PRODUCT_OPTIONS.length; i++) {
                prod = GLOBAL_PRODUCT_OPTIONS[i];
                if (prod.PRODUCT == val) {
                    val = prod.PRODUCTTEXT;
                }
            }
            return val;            
        }
        function formatEvent(val) {
            var i, evt;
            for (i = 0; i < GLOBAL_EVENT_OPTIONS.length; i++) {
                evt = GLOBAL_EVENT_OPTIONS[i];
                if (evt.EVENTTYPEID == val) {
                    val = evt.EVENTDESCRIPTION;
                }
            }
            return val;
        }

        function formatTank(val) {
            var i, tank;
            for (i = 0; i < GLOBAL_TANK_OPTIONS.length; i++) {
                tank = GLOBAL_TANK_OPTIONS[i];
                if (tank.TANK == val) {
                    val = tank.TANKNAME;
                }
            }
            return val;
        }

        function formatHeaderInspection(val) {
            var i, inspectionHeader;
            for (i = 0; i < GLOBAL_INSPECTIONS.length; i++) {
                inspectionHeader = GLOBAL_INSPECTIONS[i];
                if (inspectionHeader.INSPECTIONHEADERID == val) {
                    val = inspectionHeader.INSPECTIONHEADERTEXT;
                }
            }
            return val;
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

        function checkToSeeIfNameExist(alertName, alertID, alertType) {
            var dataSet = [];

            switch (alertType)
            {
                case 'demurrage': 
                    dataSet = GLOBAL_DEMURRAGE_GRID_DATA;
                    break;
                case 'capacity': 
                    dataSet = GLOBAL_CAPACITY_GRID_DATA;
                    break;
                case 'inactive': 
                    dataSet = GLOBAL_INACTIVE_GRID_DATA;
                    break;
                case 'dealBreaker': 
                    dataSet = GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA;
                    break;
                case 'dropTrailer': 
                    dataSet = GLOBAL_DROP_TRAILER_GRID_DATA;
                    break;
                case 'COFAUpload': 
                    dataSet = GLOBAL_COFA_UPLOAD_GRID_DATA;
                    break;
                case 'event':
                    dataSet = GLOBAL_EVENT_GRID_DATA;
                    break;
            }

            
            for (i = 0; i < dataSet.length; i++) {
                if (alertName.toLowerCase().trim() == dataSet[i].NAME.toLowerCase().trim()) {
                    if (alertID != dataSet[i].ALERTID) {
                        return true;
                    }
                }
            }
            return false;
        }


        $(function () {



            AlertMessageElement =  (function (val) {
                return {
                    getEmailSubjectLength: function () {
                        return emailSubjectLength;
                    },
                    setEmailSubjectLength: function (val) {
                        emailSubjectLength = val;
                    },
                    getEmailBodyLength: function () {
                        return EmailBodyLength;
                    },
                    setEmailBodyLength: function (val) {
                        EmailBodyLength = val;
                    },
                    getSMSSubjectLength: function () {
                        return emailSubjectLength;
                    },
                    setSMSSubjectLength: function (val) {
                        emailSubjectLength = val;
                    },
                    getSMSBodyLength: function () {
                        return EmailBodyLength;
                    },
                    setSMSBodyLength: function (val) {
                        SMSBodyLength = val;
                    },
                }
           })();

            AlertMessageElement.setEmailSubjectLength(50);
            AlertMessageElement.setEmailBodyLength(500);
            AlertMessageElement.setSMSSubjectLength(50);
            AlertMessageElement.setSMSBodyLength(160);

            setDefaultHourOptions();
            PageMethods.getDemurrageTimeInMins(onSuccess_getDemurrageTimeInMins, onFail_getDemurrageTimeInMins);
            $("#btn_ShowDemurrage").hide();
            $("#btn_ShowCapacity").hide();
            $("#btn_ShowInactive").hide();
            $("#btn_ShowDealBreaker").hide();
            $("#btn_ShowDropTrailer").hide();
            $("#btn_ShowCOFAUpload").hide();
            $("#btn_ShowEvent").hide();
        }); <%--end $(function () --%>

        function checkEmailAndSMSSubjectAndBody(grid, isEmail, isSMS, emailSub, emailBody, smsSub, smsBody) {
            //checks email part of alert is complete
            if (isEmail == true && checkNullOrUndefined(emailSub) && checkNullOrUndefined(emailBody)) {
                $(grid).data("data-isEmailAlertComplete", false);
                $(grid).data("data-isEmailSubjectEmpty", true);
                $(grid).data("data-isEmailBodyEmpty", true);
            }
            else if (isEmail == true && checkNullOrUndefined(emailSub) && !checkNullOrUndefined(emailBody)) {
                $(grid).data("data-isEmailAlertComplete", false);
                $(grid).data("data-isEmailSubjectEmpty", true);
                $(grid).data("data-isEmailBodyEmpty", false);
            }
            else if (isEmail == true && !checkNullOrUndefined(emailSub) && checkNullOrUndefined(emailBody)) {
                $(grid).data("data-isEmailAlertComplete", false);
                $(grid).data("data-isEmailSubjectEmpty", false);
                $(grid).data("data-isEmailBodyEmpty", true);
            }
            else {
                $(grid).data("data-isEmailAlertComplete", true);
                $(grid).data("data-isEmailSubjectEmpty", false);
                $(grid).data("data-isEmailBodyEmpty", false);
            }

            //checks if SMS part of alert is complete 
            if (isSMS == true && checkNullOrUndefined(smsSub) && checkNullOrUndefined(smsBody)) {
                $(grid).data("data-isSMSAlertComplete", false);
                $(grid).data("data-isSMSSubjectEmpty", true);
                $(grid).data("data-isSMSBodyEmpty", true);
            }
            else if (isSMS == true && checkNullOrUndefined(smsSub) && !checkNullOrUndefined(smsBody)) {
                $(grid).data("data-isSMSAlertComplete", false);
                $(grid).data("data-isSMSSubjectEmpty", true);
                $(grid).data("data-isSMSBodyEmpty", false);
            }
            else if (isSMS == true && !checkNullOrUndefined(smsSub) && checkNullOrUndefined(smsBody)) {
                $(grid).data("data-isSMSAlertComplete", false);
                $(grid).data("data-isSMSSubjectEmpty", false);
                $(grid).data("data-isSMSBodyEmpty", true);
            }
            else {
                $(grid).data("data-isSMSAlertComplete", true);
                $(grid).data("data-isSMSSubjectEmpty", false);
                $(grid).data("data-isSMSBodyEmpty", false);
            }
        }

        function alertAboutSubAndBodyForNewAlert(grid) {
            var isEmailAlertComplete = $(grid).data("data-isEmailAlertComplete");
            var isEmailSubjectEmpty = $(grid).data("data-isEmailSubjectEmpty");
            var isEmailBodyEmpty = $(grid).data("data-isEmailBodyEmpty");

            var isSMSAlertComplete = $(grid).data("data-isSMSAlertComplete");
            var isSMSSubjectEmpty = $(grid).data("data-isSMSSubjectEmpty");
            var isSMSBodyEmpty = $(grid).data("data-isSMSBodyEmpty");

            //check email
            if (isEmailAlertComplete == false) {
                if (isEmailSubjectEmpty == true && isEmailBodyEmpty == true) {
                    alert("The alert added is an email alert that is missing the email subject and email body. The alert will send but will only contain information on what truck triggered the alert.");
                }
                else if (isEmailSubjectEmpty == true && isEmailBodyEmpty == false) {
                    alert("The alert added is an email alert that is missing the email subject. The alert will send but the subject line will be empty.");
                }
                else if (isEmailSubjectEmpty == false && isEmailBodyEmpty == true) {
                    alert("The alert added is an email alert that is missing the email body. The alert will send with the entered subject line but will only contain information on what truck triggered the alert.");
                }
            }
            else {
                $(grid).data("data-isEmailAlertComplete", true);
                $(grid).data("data-isEmailSubjectEmpty", false);
                $(grid).data("data-isEmailBodyEmpty", false);
            }

            //check SMS
            if (isSMSAlertComplete == false) {
                if (isSMSSubjectEmpty == true && isSMSBodyEmpty == true) {
                    alert("The alert added is an text message alert that is missing the text message subject and text message body. The alert will send but will only contain information on what truck triggered the alert.");
                }
                else if (isSMSSubjectEmpty == true && isSMSBodyEmpty == false) {
                    alert("The alert added is an text message alert that is missing the text message subject. The alert will send but the subject line will be empty.");
                }
                else if (isSMSSubjectEmpty == false && isSMSBodyEmpty == true) {
                    alert("The alert added is an text message alert that is missing the text message body. The alert will send with the entered subject line but will only contain information on what truck triggered the alert.");
                }
            }
            else {
                $(grid).data("data-isSMSAlertComplete", true);
                $(grid).data("data-isSMSSubjectEmpty", false);
                $(grid).data("data-isSMSBodyEmpty", false);
            }
        }



        function alertAboutSubAndBodyForUpdateAlert(grid) {
            var isEmailAlertComplete = $(grid).data("data-isEmailAlertComplete");
            var isEmailSubjectEmpty = $(grid).data("data-isEmailSubjectEmpty");
            var isEmailBodyEmpty = $(grid).data("data-isEmailBodyEmpty");

            var isSMSAlertComplete = $(grid).data("data-isSMSAlertComplete");
            var isSMSSubjectEmpty = $(grid).data("data-isSMSSubjectEmpty");
            var isSMSBodyEmpty = $(grid).data("data-isSMSBodyEmpty");

            //check email
            if (isEmailAlertComplete == false) {
                if (isEmailSubjectEmpty == true && isEmailBodyEmpty == true) {
                    alert("The alert that was updated is an email alert that is missing the email subject and email body. The alert will send but will only contain information on what truck triggered the alert.");
                }
                else if (isEmailSubjectEmpty == true && isEmailBodyEmpty == false) {
                    alert("The alert that was updated is an email alert that is missing the email subject. The alert will send but the subject line will be empty.");
                }
                else if (isEmailSubjectEmpty == false && isEmailBodyEmpty == true) {
                    alert("The alert that was updated is an email alert that is missing the email body. The alert will send with the entered subject line but will only contain information on what truck triggered the alert.");
                }
            }
            else {
                $(grid).data("data-isEmailAlertComplete", true);
                $(grid).data("data-isEmailSubjectEmpty", false);
                $(grid).data("data-isEmailBodyEmpty", false);
            }

            //check SMS
            if (isSMSAlertComplete == false) {
                if (isSMSSubjectEmpty == true && isSMSBodyEmpty == true) {
                    alert("The alert that was updated is an text message alert that is missing the text message subject and text message body. The alert will send but will only contain information on what truck triggered the alert.");
                }
                else if (isSMSSubjectEmpty == true && isSMSBodyEmpty == false) {
                    alert("The alert that was updated is an text message alert that is missing the text message subject. The alert will send but the subject line will be empty.");
                }
                else if (isSMSSubjectEmpty == false && isSMSBodyEmpty == true) {
                    alert("The alert that was updated is an text message alert that is missing the text message body. The alert will send with the entered subject line but will only contain information on what truck triggered the alert.");
                }
            }
            else {
                $(grid).data("data-isSMSAlertComplete", true);
                $(grid).data("data-isSMSSubjectEmpty", false);
                $(grid).data("data-isSMSBodyEmpty", false);
            }
        }
         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
        function init() {
            var demurrageHeaderTextForOptions = "Before or after demurrage countdown has ended. Demurrage lasts " + GLOBAL_DEMURRAGE_TIME_IN_MINS + " minutes ";

            $("#demurrageGrid").igGrid({
                dataSource: GLOBAL_DEMURRAGE_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true,width:"0px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px"},
                    //{ headerText: "Product", key: "PRODUCT", dataType: "string", formatter: formatProducts, width: "566px" },
                    { headerText: demurrageHeaderTextForOptions, key: "TIMEOPTION", formatter: formatDemurrageTimeOptions, dataType: "string", width: "250px" },
                    { headerText: "Time till Demurrage (HH:MM)", key: "TIME", dataType: "date", format: "HH:mm", width: "100px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" },
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
                       enableAddRow: true,
                       editMode: "row",
                       enableDeleteRow: true,
                       rowEditDialogContainment: "owner",
                       showReadonlyEditors: false,
                       enableDataDirtyException: false,
                       rowDeleting: function (evt, ui) {
                           GLOBAL_ROWID = $("#demurrageGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                           GLOBAL_CURRENT_GRID = "demurrageGrid";

                           var alertName = $("#demurrageGrid").igGrid("getCellValue", ui.rowID, "NAME");
                           var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                           if (c == true) {
                               GLOBAL_CURRENT_GRID = "demurrageGrid";

                               PageMethods.disableAlert(ui.rowID, 1, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                               //PageMethods.disableDemurrageAlert(ui.rowID, onSuccess_disableDemurrageAlert, onFail_disableAlert, ui.rowID);
                           }
                           else { return false; }

                       },
                       editRowEnding: function (evt, ui) {
                           var origEvent = evt.originalEvent;
                           if (typeof origEvent === "undefined") {
                               ui.keepEditing = true;
                               return false;
                           }
                           //if (ui.update == true && ui.rowAdding == true && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                           if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               var alertTime = getNewTime(ui.values.TIME);
                               //alertTime = alertTime.slice(0, 5);
                               alertTime = convertTimeStringToMins(alertTime);

                               if (ui.values.TIMEOPTION == '-') {
                                   alertTime = (alertTime * -1)
                               }

                               GLOBAL_CURRENT_GRID = "demurrageGrid";
                               GLOBAL_ROWID = ui.values.ALERTID;


                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)){

                                   ui.keepEditing = true;
                                   return false;
                               }
                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}

                               if (checkToSeeIfNameExist(ui.values.NAME, 0, 'demurrage') == true) {
                                   ui.keepEditing = true;
                                   alert("This alert name already exist. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   checkEmailAndSMSSubjectAndBody("#demurrageGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                   PageMethods.setNewDemurrageAlert(ui.values.NAME, ui.values.EMAIL, ui.values.SMS, alertTime, //ui.values.PRODUCT,
                                                            ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                            onSuccess_setNewDemurrageAlert, onFail_setNewAlert, ui.values.ALERTID);
                               }
                           }
                               //else if (ui.update == true && ui.rowAdding == false && (evt.originalEvent.type == "click" || evt.keyCode == 13)) {
                           else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               var alertTime = getNewTime(ui.values.TIME);
                               alertTime = convertTimeStringToMins(alertTime);
                               //alertTime = alertTime.slice(0, 5);
                               if (ui.values.TIMEOPTION == '-') {
                                   alertTime = (alertTime * -1)
                               }

                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                   ui.keepEditing = true;
                                   return false;
                               }

                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               GLOBAL_CURRENT_GRID = "demurrageGrid";

                               if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'demurrage') == true) {
                                   ui.keepEditing = true;
                                   alert("There is another alert with this name. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   checkEmailAndSMSSubjectAndBody("#demurrageGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                   PageMethods.updateDemurrageAlert(ui.rowID, ui.values.NAME, ui.values.EMAIL, ui.values.SMS, alertTime,  //ui.values.PRODUCT,
                                                                    ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                    onSuccess_updateDemurrageAlert, onFail_updateDemurrageAlert);

                               }
                           }
                           else {
                               //ui.keepEditing = true;
                               return false;
                           }
                       },
                       columnSettings: [
                           {
                               columnKey: "NAME",
                               required: true
                           },
                           {
                               columnKey: "TIME",
                               editorType: "datepicker",
                               required: true,
                               editorOptions: { button: 'spin', dateInputFormat: "HH:mm" },
                           },
                            {
                                columnKey: "TIMEOPTION",
                                editorType: "combo",
                                required: true,
                                editorOptions: {
                                    mode: "editable",
                                    enableClearButton: false,
                                    dataSource: GLOBAL_DEMURRAGE_TIME_OPTIONS,
                                    id: "cboxDemurrageTime",
                                    textKey: "dOptionLabel",
                                    valueKey: "dOptionValue",
                                }
                            },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
                                 }
                       ]
                   }
                ]
            }) <%--end $("#demurrageGrid").igGrid--%>



            $("#capacityGrid").igGrid({
                dataSource: GLOBAL_CAPACITY_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true,width:"0px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px" },
                    { headerText: "Tank", key: "TANK", dataType: "number", formatter: formatTank, width: "150px" },
                    { headerText: "Tank Percentage", key: "PERCENT", dataType: "number", format: "percent", width: "85px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" }
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
                       enableAddRow: true,
                       editMode: "row",
                       enableDeleteRow: true,
                       rowEditDialogContainment: "owner",
                       showReadonlyEditors: false,
                       enableDataDirtyException: false,
                       rowDeleting: function (evt, ui) {
                           GLOBAL_ROWID = $("#capacityGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                           GLOBAL_CURRENT_GRID = "capacityGrid";

                           var alertName = $("#capacityGrid").igGrid("getCellValue", ui.rowID, "NAME");
                           var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                           if (c == true) {
                               GLOBAL_CURRENT_GRID = "capacityGrid";
                               PageMethods.disableAlert(ui.rowID, 2, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                           }
                           else { return false; }
                       },
                       editRowEnding: function (evt, ui) {
                           var orgnlEvnt = evt.originalEvent;
                           if (typeof orgnlEvnt === "undefined") {
                               ui.keepEditing = true;
                               return false;
                           }
                           var update = ui.update;

                           if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               GLOBAL_CURRENT_GRID = "capacityGrid";
                               GLOBAL_ROWID = ui.values.ALERTID;
                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                   ui.keepEditing = true;
                                   return false;
                               }
                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               if (checkToSeeIfNameExist(ui.values.NAME, 0, 'capacity') == true) {
                                   ui.keepEditing = true;
                                   alert("This alert name already exist. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   if (ui.values.PERCENT <= 0 || ui.values.PERCENT > 1) {
                                       alert("Invalid percentage. Please enter another value and try again.");
                                       return false;
                                   }
                                   else {
                                       checkEmailAndSMSSubjectAndBody("#capacityGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                       PageMethods.setNewCapacityAlert(ui.values.NAME, ui.values.PERCENT, ui.values.EMAIL, ui.values.SMS, ui.values.TANK,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_setNewCapacityAlert, onFail_setNewAlert, ui.values.ALERTID);
                                   }
                               }
                           }
                           else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                               GLOBAL_CURRENT_GRID = "capacityGrid";
                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                   ui.keepEditing = true;
                                   return false;
                               }
                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'capacity') == true) {
                                   ui.keepEditing = true;
                                   alert("There is another alert with this name. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   if (ui.values.PERCENT <= 0 || ui.values.PERCENT > 1) {
                                       alert("Invalid percentage. Please enter another value and try again.");
                                       return false;
                                   }
                                   else {
                                       checkEmailAndSMSSubjectAndBody("#capacityGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                       PageMethods.updateCapacityAlert(ui.rowID, ui.values.NAME, ui.values.PERCENT, ui.values.EMAIL, ui.values.SMS, ui.values.TANK,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_updateCapacityAlert, onFail_updateCapacityAlert);
                                   }
                               }
                           }
                           else {
                               //ui.keepEditing = true;
                               return false;
                           }
                       },
                       columnSettings: [
                           {
                               columnKey: "NAME",
                               required: true
                           },
                           {
                               columnKey: "TANK",
                               editorType: "combo",
                               required: true,
                               editorOptions: {
                                   mode: "editable",
                                   enableClearButton: false,
                                   dataSource: GLOBAL_TANK_OPTIONS,
                                   id: "cboxTank",
                                   textKey: "TANKNAME",
                                   valueKey: "TANK"
                               }
                           },
                           {
                               columnKey: "PERCENT",
                               required: true,
                               editorType: "percent",
                               editorOptions: {
                                   button: 'spin',
                                   minValue: 0,
                                   maxDecimals: 3,
                                   maxValue: 100
                               },
                           },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
                                 }
                       ]
                   }
                ]
            }) <%--end $("#capacityGrid").igGrid--%>


            $("#inactiveGrid").igGrid({
                dataSource: GLOBAL_INACTIVE_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true,width:"0px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px" },
                    { headerText: "Inactive Time (HH:MM)", key: "TIME", dataType: "datetime", format: "HH:mm", width: "100px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" }
                ],
                features: [
                    { name: 'Paging' },
                    { name: 'Resizing' },
                    {
                        name: "Filtering",
                        allowFiltering: true,
                        caseSensitive: false
                    },
                    { name: 'Sorting' },
                   {
                       name: "Updating",
                       enableAddRow: true,
                       editMode: "row",
                       enableDeleteRow: true,
                       rowEditDialogContainment: "owner",
                       showReadonlyEditors: false,
                       enableDataDirtyException: false,
                       editRowStarted: function (evt, ui) { },
                       rowDeleting: function (evt, ui) {
                           LOBAL_ROWID = $("#inactiveGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                           GLOBAL_CURRENT_GRID = "inactiveGrid";

                           var alertName = $("#inactiveGrid").igGrid("getCellValue", ui.rowID, "NAME");
                           var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                           if (c == true) {
                               GLOBAL_CURRENT_GRID = "inactiveGrid";
                               PageMethods.disableAlert(ui.rowID, 3, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                           }
                           else { return false; }
                       },
                       editRowEnding: function (evt, ui) {
                           var newTime;
                           var origEvent = evt.originalEvent;
                           if (typeof origEvent === "undefined") {
                               ui.keepEditing = true;
                               return false;
                           }
                           if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                               GLOBAL_CURRENT_GRID = "inactiveGrid";
                               newTime = getNewTime(ui.values.TIME);
                               //newTime = newTime.slice(0, 5);
                               newTime = convertTimeStringToMins(newTime);
                               GLOBAL_ROWID = ui.values.ALERTID;
                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                   ui.keepEditing = true;
                                   return false;
                               }
                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               if (checkToSeeIfNameExist(ui.values.NAME, 0, 'inactive') == true) {
                                   ui.keepEditing = true;
                                   alert("This alert name already exist. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   checkEmailAndSMSSubjectAndBody("#inactiveGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                   PageMethods.setNewInactiveAlert(ui.values.NAME, newTime, ui.values.EMAIL, ui.values.SMS,
                                                                    ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                    onSuccess_setNewInactiveAlert, onFail_setNewAlert, ui.values.ALERTID);
                               }
                           }
                           else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                               GLOBAL_CURRENT_GRID = "inactiveGrid";
                               newTime = getNewTime(ui.values.TIME);
                               //newTime = newTime.slice(0, 5);
                               newTime = convertTimeStringToMins(newTime);
                               if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                   ui.keepEditing = true;
                                   return false;
                               }

                               //if (ui.values.EMAILSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Email Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.EMAILBODY.length > 500) {
                               //    ui.keepEditing = true;
                               //    alert("Email Body is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSSUB.length > 50) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               //if (ui.values.SMSBODY.length > 160) {
                               //    ui.keepEditing = true;
                               //    alert("Text Message Subject is too long");
                               //    return false;
                               //}
                               if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'inactive') == true) {
                                   ui.keepEditing = true;
                                   alert("There is another alert with this name. Please re-name and try saving again");
                                   return false;
                               }
                               else {
                                   checkEmailAndSMSSubjectAndBody("#inactiveGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                   PageMethods.updateInactiveAlert(ui.rowID, ui.values.NAME, newTime, ui.values.EMAIL, ui.values.SMS,
                                                                    ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                    onSuccess_updateInactiveAlert, onFail_updateInactiveAlert);
                               }
                           }
                           else {
                               //ui.keepEditing = true;
                               return false;
                           }
                       },
                       columnSettings: [
                           {
                               columnKey: "NAME",
                               required: true
                           },
                           {
                               columnKey: "TIME",
                               editorType: "datepicker",
                               required: true,
                               editorOptions: { button: 'spin', dateInputFormat: "HH:mm" },
                           },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
                                 }
                       ]
                   },
                ]
            }) <%--end $("#inactiveGrid").igGrid--%>

            $("#inspectionDealBreakerGrid").igGrid({
                dataSource: GLOBAL_INSPECTION_DEALBREAKER_GRID_DATA,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true ,width:"0px"},
                    { headerText: "Name", key: "NAME", dataType: "string" , width:"350px" },
                    { headerText: "Inspection Title Text", key: "HEADERID", dataType: "string", formatter: formatHeaderInspection, width: "550px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" },
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
                        enableAddRow: true,
                        editMode: "row",
                        enableDeleteRow: true,
                        rowEditDialogContainment: "owner",
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        rowDeleting: function (evt, ui) {
                            GLOBAL_ROWID = $("#inspectionDealBreakerGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                            GLOBAL_CURRENT_GRID = "inspectionDealBreakerGrid";

                            var alertName = $("#inspectionDealBreakerGrid").igGrid("getCellValue", ui.rowID, "NAME");
                            var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                            if (c == true) {
                                GLOBAL_CURRENT_GRID = "inspectionDealBreakerGrid";
                                PageMethods.disableAlert(ui.rowID, 4, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                            }
                            else { return false; }

                        },
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                //var alertTime = getNewTime(ui.values.TIME);
                                //alertTime = alertTime.slice(0, 5);
                                GLOBAL_CURRENT_GRID = "inspectionDealBreakerGrid";
                                //GLOBAL_ROWID = ui.values.ALERTID;
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }
                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                if (checkToSeeIfNameExist(ui.values.NAME, 0, 'dealBreaker') == true) {
                                    ui.keepEditing = true;
                                    alert("This alert name already exist. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#inspectionDealBreakerGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.setNewDealBreakerAlert(ui.values.NAME, ui.values.HEADERID, ui.values.EMAIL, ui.values.SMS,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_setNewDealBreakerAlert, onFail_setNewAlert, ui.values.ALERTID);
                                }
                            }
                            else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                GLOBAL_CURRENT_GRID = "inspectionDealBreakerGrid";
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }
                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'dealBreaker') == true) {
                                    ui.keepEditing = true;
                                    alert("There is another alert with this name. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#inspectionDealBreakerGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.updateDealBreakersAlert(ui.rowID, ui.values.NAME, ui.values.HEADERID, ui.values.EMAIL, ui.values.SMS,
                                                                            ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                            onSuccess_updateDealBreakersAlert, onFail_updateDealBreakersAlert);
                                }
                            }
                            else {
                                return false;
                            }
                        },
                        columnSettings: [
                           {
                               columnKey: "NAME",
                               required: true
                           },
                            {
                                columnKey: "HEADERID",
                                editorType: "combo",
                                required: true,
                                nullText: 'enter product name or product id',
                                editorOptions: {
                                    mode: "editable",
                                    enableClearButton: false,
                                    nullText: 'enter product name or product id',
                                    dataSource: GLOBAL_INSPECTIONS,
                                    id: "cboxInspection",
                                    textKey: "INSPECTIONHEADERTEXT",
                                    valueKey: "INSPECTIONHEADERID"
                                }
                            },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
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
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width:"0px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px" },
                    { headerText: "Hours", key: "HOURS", dataType: "number", width: "200px" },
                    { headerText: "Minute", key: "MINS", dataType: "number", width: "75px" },
                    { headerText: "Product", key: "PRODUCT", dataType: "string", formatter: formatProducts, width: "500px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" },
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
                        enableAddRow: true,
                        editMode: "row",
                        enableDeleteRow: true,
                        rowEditDialogContainment: "owner",
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        rowDeleting: function (evt, ui) {
                            GLOBAL_ROWID = $("#dropTrailerGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                            GLOBAL_CURRENT_GRID = "dropTrailerGrid";

                            var alertName = $("#dropTrailerGrid").igGrid("getCellValue", ui.rowID, "NAME");
                            var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                            if (c == true) {
                                GLOBAL_CURRENT_GRID = "dropTrailerGrid";

                                PageMethods.disableAlert(ui.rowID, 5, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                            }
                            else { return false; }

                        },
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }
                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                var mins = convertHoursToMins(ui.values.HOURS);
                                mins + ui.values.mins;

                                if (checkToSeeIfNameExist(ui.values.NAME, 0, 'dropTrailer') == true) {
                                    ui.keepEditing = true;
                                    alert("This alert name already exist. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#dropTrailerGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.setNewDropTrailerAlert(ui.values.NAME, ui.values.PRODUCT, mins, ui.values.EMAIL, ui.values.SMS,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_setNewDropTrailerAlert, onFail_setNewAlert, ui.values.ALERTID);
                                }
                            }
                            else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }
                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                var mins = convertHoursToMins(ui.values.HOURS);
                                mins + ui.values.mins;

                                if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'dropTrailer') == true) {
                                    ui.keepEditing = true;
                                    alert("There is another alert with this name. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#dropTrailerGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.updateDropTrailerAlert(ui.rowID, ui.values.NAME, ui.values.PRODUCT, mins, ui.values.EMAIL, ui.values.SMS,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_updateDropTrailerAlert, onFail_updateDropTrailerAlert);
                                }
                            }
                            else {
                                //ui.keepEditing = true;
                                return false;
                            }
                        },
                        columnSettings: [
                            {
                                columnKey: "NAME",
                                required: true
                            },
                           {
                               columnKey: "HOURS",
                               editorType: "combo",
                               required: true,
                               editorOptions: {
                                   mode: "editable",
                                   enableClearButton: false,
                                   dataSource: GLOBAL_HOUR_OPTIONS,
                                   textKey: "label",
                                   valueKey: "value",
                                   id: "cboxHours",
                                   allowCustomValue: true,
                                   //listItems: [
                                   //    0, 8, 16, 24, 36, 48, 60
                                   //],
                               }
                           },
                            {
                                columnKey: "PRODUCT",
                                editorType: "combo",
                                required: true,
                                editorOptions: {
                                    mode: "editable",
                                    enableClearButton: false,
                                    dataSource: GLOBAL_PRODUCT_OPTIONS,
                                    id: "cboxProduct",
                                    textKey: "PRODUCTTEXT",
                                    valueKey: "PRODUCT",
                                    filtering: function (evt, ui) {
                                        var cBoxProdInput = $(evt.currentTarget).attr("value");
                                        var cBoxProdLength = cBoxProdInput.length;

                                        if (cBoxProdLength >= 3 && FILTERTEXT.length < 2) {
                                            FILTERTEXT = cBoxProdInput;
                                            GLOBAL_ROWID = ui.rowID;
                                            PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductListBasedOnInput, onFail_getProductListBasedOnInput,
                                                                                     "dropTrailer");
                                        }
                                        else if (cBoxProdLength >= 3 && FILTERTEXT.length >= 3) {
                                            FILTERTEXT = FILTERTEXT.substring(0, cBoxProdLength)
                                            if (FILTERTEXT != cBoxProdInput) {
                                                FILTERTEXT = cBoxProdInput;
                                                GLOBAL_ROWID = ui.rowID;
                                                PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductListBasedOnInput, onFail_getProductListBasedOnInput, "dropTrailer");
                                            }
                                        }
                                    }
                                }
                            },
                                 {
                                     columnKey: "MINS",
                                     editorType: "numeric",
                                     required: true,
                                     mode: 'dropdown',
                                     dataMode: "int",
                                     editorOptions: {
                                         //listItems : [
                                         //    0,15,30,45
                                         //],
                                         dataMode: "int",
                                         maxDecimals: 0,
                                         button: 'spin',
                                         readOnly: true,
                                         spinOnReadOnly: true,
                                         spinWrapAround: true,
                                         listMatchOnly: true,
                                         enableClearButton: false,
                                         minValue: 00,
                                         maxValue: 45,
                                         spinDelta: 15,
                                         required: true,
                                         autoSelectFirstMatch: true,
                                         valueChanging: function (evt, ui) {
                                             //alert(ui);
                                         }
                                     }
                                 },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
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
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "ALERTID",
                columns: [
                    { headerText: "", key: "ALERTID", dataType: "number", hidden: true, width:"0px" },
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px" },
                    { headerText: "Alert Time (HH:MM)", key: "TIME", dataType: "datetime", format: "HH:mm", width: "100px" },
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" },
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
                        enableAddRow: true,
                        editMode: "row",
                        enableDeleteRow: true,
                        rowEditDialogContainment: "owner",
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        rowDeleting: function (evt, ui) {
                            GLOBAL_ROWID = $("#COFAUploadGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                            GLOBAL_CURRENT_GRID = "COFAUploadGrid";

                            var alertName = $("#COFAUploadGrid").igGrid("getCellValue", ui.rowID, "NAME");
                            var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                            if (c == true) {
                                GLOBAL_CURRENT_GRID = "COFAUploadGrid";

                                PageMethods.disableAlert(ui.rowID, 6, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                                //PageMethods.disableCOFAUploadAlert(ui.rowID, onSuccess_disableCOFAUploadAlert, onFail_disableAlert, ui.rowID);
                            }
                            else { return false; }

                        },
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }

                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                var alertTime = getNewTime(ui.values.TIME);
                                //alertTime = alertTime.slice(0, 5);
                                alertTime = convertTimeStringToMins(alertTime);

                                if (checkToSeeIfNameExist(ui.values.NAME, 0, 'COFAUpload') == true) {
                                    ui.keepEditing = true;
                                    alert("This alert name already exist. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#COFAUploadGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.setNewCOFAUploadAlert(ui.values.NAME, alertTime, ui.values.EMAIL, ui.values.SMS,
                                                                        ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                        onSuccess_setNewCOFAUploadAlert, onFail_setNewAlert, ui.values.ALERTID);
                                }
                            }
                            else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }

                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                var alertTime = getNewTime(ui.values.TIME);
                                //alertTime = alertTime.slice(0, 5);
                                alertTime = convertTimeStringToMins(alertTime);

                                if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'COFAUpload') == true) {
                                    ui.keepEditing = true;
                                    alert("There is another alert with this name. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    checkEmailAndSMSSubjectAndBody("#COFAUploadGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.updateCOFAUploadAlert(ui.rowID, ui.values.NAME, alertTime, ui.values.EMAIL, ui.values.SMS,
                                                                       ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                       onSuccess_updateCOFAUploadAlert, onFail_updateCOFAUploadAlert);
                                }
                            }
                            else {
                                //ui.keepEditing = true;
                                return false;
                            }
                        },
                        columnSettings: [
                           {
                               columnKey: "TIME",
                               editorType: "datepicker",
                               required: true,
                               editorOptions: { button: 'spin', dateInputFormat: "HH:mm" },
                           },
                            {
                                columnKey: "NAME",
                                required: true
                            },
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
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
                    { headerText: "Name", key: "NAME", dataType: "string", width: "350px" },
                    { headerText: "Event", key: "EVENT", dataType: "string", formatter: formatEvent, width: "500px" },
                    <%--//{ headerText: "Products to Associate Alert to", key: "PRODUCT", dataType: "string", formatter: formatProducts, width: "500px" },--%>
                    { headerText: "Email Subject  (max. 50 characters)", key: "EMAILSUB", dataType: "string", width: "350px" },
                    { headerText: "Email Body (max. 500 characters)", key: "EMAILBODY", dataType: "string", width: "550px" },
                    { headerText: "SMS Subject  (max. 50 characters)", key: "SMSSUB", dataType: "string", width: "350px" },
                    { headerText: "SMS Body (max. 160 characters)", key: "SMSBODY", dataType: "string", width: "550px" },
                    { headerText: "Email Alert", key: "EMAIL", dataType: "bool", width: "75px" },
                    { headerText: "Text Alert", key: "SMS", dataType: "bool", width: "75px" },
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
                        enableAddRow: true,
                        editMode: "row",
                        enableDeleteRow: true,
                        rowEditDialogContainment: "owner",
                        showReadonlyEditors: false,
                        enableDataDirtyException: false,
                        rowDeleting: function (evt, ui) {
                            GLOBAL_ROWID = $("#eventGrid").igGrid("getCellValue", ui.rowID, "ALERTID");
                            GLOBAL_CURRENT_GRID = "eventGrid";

                            var alertName = $("#eventGrid").igGrid("getCellValue", ui.rowID, "NAME");
                            var c = confirm("Continue deleting request for " + alertName + "? Deletion cannot be undone.");

                            if (c == true) {
                                GLOBAL_CURRENT_GRID = "eventGrid";

                                PageMethods.disableAlert(ui.rowID, 1007, onSuccess_disableAlert, onFail_disableAlert, ui.rowID);
                            }
                            else { return false; }

                        },
                        editRowEnding: function (evt, ui) {
                            var origEvent = evt.originalEvent;
                            if (typeof origEvent === "undefined") {
                                ui.keepEditing = true;
                                return false;
                            }
                            if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }

                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                if (checkToSeeIfNameExist(ui.values.NAME, 0, 'event') == true) {
                                    ui.keepEditing = true;
                                    alert("This alert name already exist. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    <%--//if (ui.values.PRODUCT != "All Products") {
                                    //    prod = ui.values.PRODUCT;
                                    //}--%>

                                    var prod = null;
                                    checkEmailAndSMSSubjectAndBody("#eventGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.setNewEventAlert(ui.values.NAME, prod, ui.values.EVENT, ui.values.EMAIL, ui.values.SMS,
                                                                    ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                    onSuccess_setNewEventAlert, onFail_setNewAlert, ui.values.ALERTID);
                                }
                            }
                            else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                if (isEmailBodyTooLong(ui.values.EMAILBODY)
                                   || isEmailSubjectTooLong(ui.values.EMAILSUB)
                                   || isSMSSubjectTooLong(ui.values.SMSSUB)
                                   || isSMSBodyTooLong(ui.values.SMSBODY)) {

                                    ui.keepEditing = true;
                                    return false;
                                }

                                //if (ui.values.EMAILSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Email Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.EMAILBODY.length > 500) {
                                //    ui.keepEditing = true;
                                //    alert("Email Body is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSSUB.length > 50) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                //if (ui.values.SMSBODY.length > 160) {
                                //    ui.keepEditing = true;
                                //    alert("Text Message Subject is too long");
                                //    return false;
                                //}
                                if (checkToSeeIfNameExist(ui.values.NAME, ui.rowID, 'event') == true) {
                                    ui.keepEditing = true;
                                    alert("There is another alert with this name. Please re-name and try saving again");
                                    return false;
                                }
                                else {
                                    <%--//if (ui.values.PRODUCT != "All Products") {
                                    //    prod = ui.values.PRODUCT;
                                    //}--%>
                                    var prod = null;
                                    checkEmailAndSMSSubjectAndBody("#eventGrid", ui.values.EMAIL, ui.values.SMS, ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY)
                                    PageMethods.updateEventAlert(ui.rowID, ui.values.NAME, prod, ui.values.EVENT, ui.values.EMAIL, ui.values.SMS,
                                                                    ui.values.EMAILSUB, ui.values.EMAILBODY, ui.values.SMSSUB, ui.values.SMSBODY,
                                                                    onSuccess_updateEventAlert, onFail_updateEventAlert, ui.values.ALERTID);
                                }
                            }
                            else {
                                //ui.keepEditing = true;
                                return false;
                            }
                        },
                        columnSettings: [
                            {
                                columnKey: "NAME",
                                required: true
                            },
                            {
                                columnKey: "EVENT",
                                editorType: "combo",
                                required: true,
                                editorOptions: {
                                    mode: "editable",
                                    enableClearButton: false,
                                    dataSource: GLOBAL_EVENT_OPTIONS,
                                    id: "cboxEvent",
                                    textKey: "EVENTDESCRIPTION",
                                    valueKey: "EVENTTYPEID"
                                }
                            },
                        <%--{
                            columnKey: "PRODUCT",
                            editorType: "combo",
                            required: false,
                            editorOptions: {
                                mode: "editable",
                                enableClearButton: false,
                                dataSource: GLOBAL_PRODUCT_OPTIONS_FOR_EVENT_ALERTS,
                                id: "cboxProduct",
                                textKey: "PRODUCTTEXT",
                                valueKey: "PRODUCT",
                                filtering: function (evt, ui) {
                                    var cBoxProdInput = $(evt.currentTarget).attr("value");
                                    var cBoxProdLength = cBoxProdInput.length;

                                    if (cBoxProdLength >= 3 && FILTERTEXT.length < 2) {
                                        FILTERTEXT = cBoxProdInput;
                                        GLOBAL_ROWID = ui.rowID;
                                        PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductListBasedOnInput_ForEventAlerts, onFail_getProductListBasedOnInput);
                                    }
                                    else if (cBoxProdLength >= 3 && FILTERTEXT.length >= 3) {
                                        FILTERTEXT = FILTERTEXT.substring(0, cBoxProdLength)
                                        if (FILTERTEXT != cBoxProdInput) {
                                            FILTERTEXT = cBoxProdInput;
                                            GLOBAL_ROWID = ui.rowID;
                                            PageMethods.getProductListBasedOnInput(cBoxProdInput, onSuccess_getProductListBasedOnInput_ForEvents, onFail_getProductListBasedOnInput);
                                        }
                                    }
                                }
                            }
                        },--%>
                                 {
                                     columnKey: "EMAILSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "EMAILBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 500
                                     }
                                 },
                                 {
                                     columnKey: "SMSSUB",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 50
                                     }
                                 },
                                 {
                                     columnKey: "SMSBODY",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 160
                                     }
                                 }


                        ]
                    }
                ]
            }) <%--end $("#eventGrid").igGrid--%>

        }; <%--end of function init()--%>
    </script>


    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <%--<h3>Select a row to edit an alert or click 'Add new row' to add a new alert</h3>--%>
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDemurrage()" value="Hide Grid" id="btn_HideDemurrage"/> <input type="button" onclick="onclick_ShowDemurrage()" value="Show Grid" id="btn_ShowDemurrage"/></div><h2>Demurrage Alerts</h2></div>
    <div id="demurrageGridWrapper"><table id="demurrageGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideCapacity()" value="Hide Grid" id="btn_HideCapacity"/> <input type="button" onclick="onclick_ShowCapacity()" value="Show Grid" id="btn_ShowCapacity"/></div><h2>Tank Capacity Alerts</h2></div>
    <div id="capacityGridWrapper"><table id="capacityGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideInactive()" value="Hide Grid" id="btn_HideInactive"/> <input type="button" onclick="onclick_ShowInactive()" value="Show Grid" id="btn_ShowInactive"/></div><h2>Inactive Truck Alerts</h2></div>
    <div id="inactiveGridWrapper"><table id="inactiveGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDealBreaker()" value="Hide Grid" id="btn_HideDealBreaker"/> <input type="button" onclick="onclick_ShowDealBreaker()" value="Show Grid" id="btn_ShowDealBreaker"/></div><h2>Inspection Deal Breaker Alerts</h2></div>
    <div id="inspectionDealBreakerGridWrapper"><table id="inspectionDealBreakerGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideDropTrailer()" value="Hide Grid" id="btn_HideDropTrailer"/> <input type="button" onclick=" onclick_ShowDropTrailer()" value="Show Grid" id="btn_ShowDropTrailer"/></div><h2>Drop Trailer Alerts</h2></div>
    <div id="dropTrailerGridWrapper"><table id="dropTrailerGrid" class="scrollGridClass"></table></div>
    
    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideCOFAUpload()" value="Hide Grid" id="btn_HideCOFAUpload"/> <input type="button" onclick="onclick_ShowCOFAUpload()" value="Show Grid" id="btn_ShowCOFAUpload"/></div><h2>COFA Upload Alerts</h2></div>
    <div id="COFAUploadGridWrapper"><table id="COFAUploadGrid" class="scrollGridClass"></table></div>

    <br /><br />
    <div><div style="float:right"><input type="button" onclick="onclick_HideEvent()" value="Hide Grid" id="btn_HideEvent"/> <input type="button" onclick="onclick_ShowEvent()" value="Show Grid" id="btn_ShowEvent"/></div><h2>Event Driven Alerts</h2></div>
    <div id="EventGridWrapper"><table id="eventGrid" class="scrollGridClass"></table></div>

</asp:Content>
