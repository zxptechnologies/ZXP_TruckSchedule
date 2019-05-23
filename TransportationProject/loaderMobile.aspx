<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="loaderMobile.aspx.cs" Inherits="TransportationProject.loaderMobile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true" ScriptMode="Release">
    </asp:ScriptManager>
    <link href="Content/buttonStyles.css" rel="stylesheet" />
    <script src="Scripts/InspectionsQuestions.js"></script>

       

     <script type="text/javascript">
                
         
        var versionIE = detectIE();
        if (versionIE && versionIE < 12) 
        {
            document.write('<script src="Scripts/TruckScheduleJS/TruckScheduleClassesIE.js"><\/script>'); <%-- need to escape the closing script tag --%>
                    
        }
        else {
            document.write('<script src="Scripts/TruckScheduleJS/TruckScheduleClasses.js"><\/script>'); 
        }
          

         function initGrid() {


             $("#loaderQuickGrid").igGrid({
                    dataSource: null,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    autofitLastColumn: true,
                    renderCheckboxes: true,
                    primaryKey: "MSID",
                    columns:
                     [
                            { headerText: "", key: "MSID", dataType: "number", width: "0%", hidden: true },
                            { headerText: "", key: "StatusID", dataType: "number", width: "0%", hidden: true },
                            { headerText: "", key: "SpotID", dataType: "number", width: "0%", hidden: true },
                            { headerText: "", key: "PODetailsID", dataType: "number", width: "0%", hidden: true },
                            { headerText: "", key: "LoadType", dataType: "string", width: "0%", hidden: true },
                            { headerText: "", key: "ETA", dataType: "date", width: "0%", hidden: true },
                            { headerText: "PONumber", key: "PONumber", dataType: "string", width: "20%" },
                            { headerText: "Product", key: "ProdID", dataType: "string", width: "20%" },
                            { headerText: "Product Detail", key: "ProdName", dataType: "string", width: "20%"},
                            { headerText: "Scheduled Spot", key: "SpotName", dataType: "string", width: "12.5%" },
                            { headerText: "Status", key: "StatusName", dataType: "string", width: "12.5%" },
                            { headerText: "Trailer", key: "Trailer", dataType: "string", width: "15%" }
                            
                     ],
                     features: [
                         {
                             name: 'Paging'
                         },
                         {
                             name: 'Updating',
                             enableAddRow: false,
                             editMode: "row",
                             enableDeleteRow: false,
                             validation: true,
                             showReadonlyEditors: false,
                             enableDataDirtyException: false,
                             autoCommit: false,
                             editRowStarting: function (evt, ui) {
                                 var MSID = ui.rowID;
                                 
                                var product = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "ProdID");
                                var trailer = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "Trailer");
                                 var POnumber = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "PONumber");

                                 $("#TruckButtonsDialogBox").data("data-MSID", MSID);
                                 $("#TruckButtonsDialogBox").igDialog("option", "headerText", "PO:" + POnumber + " - Product: " + product + "- Trailer: " + trailer);
                                 refreshInspectionListDataAndbuttons();

                             },
                             columnSettings: [
                                 { columnKey: "ProdID", readOnly: true },
                                 { columnKey: "ProdName", readOnly: true },
                                 { columnKey: "SpotName", readOnly: true },
                                 { columnKey: "StatusName", readOnly: true },
                                 { columnKey: "Trailer", readOnly: true },
                                 { columnKey: "PONumber", readOnly: true }
                                 
                             ]
                         },
                         {
                            name: 'Sorting'
                         },
                         {
                             name: "Filtering",
                             dataFiltering: function (evt, ui) {
                                var newThng = [];
                                var nExpressions = [];
                                var check = ui.expressions;
                                for (i = 0; i < ui.newExpressions.length; i++) {
                                    var newcond = ui.newExpressions[i].cond;
                                    var newExpr = ui.newExpressions[i].expr;
                                    var newFieldName = ui.newExpressions[i].fieldName;

                                    if (!checkNullOrUndefined(newExpr)) {
                                        nExpressions.push(ui.newExpressions[i]);
                                    }
                                }
                                $("#loaderQuickGrid").igGridFiltering("filter", nExpressions);
                                return false;
                            }
                         }
                     ]
             });
         }//initGrid

         function checkForRedirect() {

             var url_string = window.location.href;
             var url = new URL(url_string);
             var MSIDRedirect = url.searchParams.get("MSID");
             if (MSIDRedirect) {
                 $("#loaderQuickGrid").igGridFiltering("filter", ([{
                     fieldName: "MSID",
                     expr: MSIDRedirect,
                     cond: "equals"
                 }]), true);
             }
         }

         function clearGridFilter(evt, ui) {
            $("#loaderQuickGrid").igGridFiltering("filter", [], true);
         }
       
     
        function onclick_ShowTodaysScheduledTrucks(evt, ui) {

            clearGridFilter();

            var todayDate = new Date();
            $("#loaderQuickGrid").igGridFiltering("filter",
                [{ fieldName: "ETA", expr: todayDate.toDateString(), cond: "on" }],
                true);
         }
         
         function onclick_ClearGrid(){
             clearGridFilter();
         }

         function initPopUps() {
            var getInspectionObjectFromMem = function () { <%--Global function Var--%>
                return this.inspectionListData;
            };
        var selectedInspectionListData;<%--Global  Var--%>

        function clearButtonDivs() {
            $("#dvButtonsInspections").empty();
            $("#dvButtonsSample").empty();
            $("#dvButtonsLoadUnload").empty();
            $("#dvButtonsRejectTruck").empty();
        }

             $("#TruckButtonsDialogBox").igDialog({
                 width: "100%", 
                 height: "100%",
                 state: "closed",
                 resizable: false,
                 modal: true,
                 draggable: false,
                 showCloseButton: false,
                 stateChanging: function (evt, ui) {
                     if (ui.action === "close")
                     {
                         clearButtonDivs();
                     }
                     else
                     {
                         $("#TruckButtonsDialogBox").show();
                     }
                 }
                 
             });

             

              $("#dwInspectionQuestions").igDialog({
                width: "100%",
                height: "100%",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "open") {
                        $("#tblQuestions").data("questNum", 1);
                    }
                    else {
                        refreshInspectionListDataAndbuttons();
                    }
                   
                }
            });
         }

        function parseforInspectionGridData(InspectionListDetails) {
            var gridData = [];
            for (i = 0; i < InspectionListDetails.length; i++) {
                var inspectionObj = InspectionListDetails[i].MSInspection;
                gridData[i] = {
                    "MSInspectionListID": InspectionListDetails[i].MSInspectionListID,
                    "SortOrder": InspectionListDetails[i].SortOrder,
                    "MSInspectionID": inspectionObj.MSInspectionID,
                    "InspectionHeaderID": inspectionObj.InspectionHeaderID,
                    "MSInspectionListDetailID": inspectionObj.MSInspectionListDetailID,
                    "InspectionStartEventID": inspectionObj.InspectionStartEventID,
                    "InspectionEndEventID": inspectionObj.InspectionEndEventID,
                    "InspectionHeaderName": inspectionObj.InspectionHeaderName,
                    "InspectionTypeID": inspectionObj.InspectionTypeID,
                    "LoadType": inspectionObj.LoadType,
                    "UserID": inspectionObj.UserID,
                    "RunNumber": inspectionObj.RunNumber,
                    "InspectionComment": inspectionObj.InspectionComment,
                    "needsVerificationTest": (inspectionObj.needsVerificationTest) ? 1 : 0,
                    "isFailed": (inspectionObj.isFailed) ? 1 : 0,
                    "wasAutoClosed": inspectionObj.wasAutoClosed,
                    "Complete": (checkNullOrUndefined(inspectionObj.InspectionEndEventID) ? 0 : 1),
                    "Details": "",
                    "UserWhoLastModified": inspectionObj.UserLastModified,
                    "UserWhoPerformedVerification": inspectionObj.UserVerifying,
                    "UserWhoCreated": inspectionObj.userWhoCreated,
                    "LastModifiedTime": inspectionObj.lastModifiedTimestamp
                };
            }
            return gridData;
         }

        var getInspectionObjectFromMem = function () { <%--Global function Var--%>
            return this.inspectionListData;
        };
        var selectedInspectionListData;<%--Global  Var--%>

         function closeIGDialog(DialogName) {
            $("#" + DialogName).igDialog("close");
         }
         
         function onclick_TruckButtonsDialogBox_Inspection1() {
            $("#TruckButtonsDialogBox").igDialog("close");
         }
         function onclick_TruckButtonsDialogBox_Sample() {
            var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             var param = "MSID=" + MSID;
             var redirect = "Samples.aspx?" + param;
             window.location = redirect;
             $("#TruckButtonsDialogBox").igDialog("close");
         }
         function onclick_TruckButtonsDialogBox_Inspection2() {
             alert("Inspection2");
             $("#TruckButtonsDialogBox").igDialog("close");
         }
         function onclick_TruckButtonsDialogBox_LoadRequestStart(loadtype, requestID, requestTypeID) {
             
            var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             var statID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "StatusID");
             if (1 !== statID && 10 !== statID) {
                     PageMethods.startRequest(requestID, requestTypeID, MSID, onSuccess_startRequest, onFail_startRequest);

             }
             else if (10 === statID) {
                 var loadMessage = 'unloading';
                 if ('load' === loadtype.toLowerCase()) { loadMessage = 'loading'; }
                 var response = confirm("Truck has left ZXP. Continue to start " + loadMessage + " ?");
                 if (response) {
                     PageMethods.startRequest(requestID, requestTypeID, MSID, onSuccess_startRequest, onFail_startRequest);
                     
                 }
             }
             //Removed as of 2/8/2019- Lunch Meeting
            // $("#TruckButtonsDialogBox").igDialog("close");
             
             
         }
         function onclick_TruckButtonsDialogBox_LoadRequestEnd(loadtype, requestID, requestTypeID  ) {
        
             
             var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             var statID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "StatusID");
             if (1 !== statID && 10 !== statID) {
                     PageMethods.completeRequest(requestID, requestTypeID, MSID, onSuccess_completeRequest, onFail_completeRequest);
             }
             else if (10 === statID) {
                 var loadMessage = 'unloading';
                 if ('load' === loadtype.toLowerCase()) { loadMessage = 'loading'; }
                 var response = confirm("Truck has left ZXP. Continue to end " + loadMessage + " ?");
                 if (response) {
                     PageMethods.completeRequest(requestID, requestTypeID, MSID, onSuccess_completeRequest, onFail_completeRequest);
                 }
             }
             
             //Removed as of 2/8/2019- Lunch Meeting
            // $("#TruckButtonsDialogBox").igDialog("close");
         }

         function onclick_TruckButtonsDialogBox_Close() {
             $("#TruckButtonsDialogBox").igDialog("close");
         }
         
         function onclick_TruckButtonsDialogBox_RejectTruck() {
            var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             var param = "MSID=" + MSID;
             var redirect = "rejectTruck.aspx?" + param;
             window.location = redirect;
             $("#TruckButtonsDialogBox").igDialog("close");
         }
             
         function getHTMLStringForLoadUnloadButton(requestData, isStart) {
             var htmlstring = "";
             var buttonTitle = "";
             var requestTypeID = requestData["RequestTypeID"];
             if (1 === requestTypeID) { //Load
                 buttonTitle = "Load"; 
             }
             else if (2 === requestTypeID) { //Unload
                 buttonTitle = "Unload";
             }
             var parsedDate;
             if (isStart) {
                 var timeStart = requestData["TimeRequestStart"];
                 if (timeStart) {
                     htmlstring = '<button id=\"btnLoadStart'+ requestData["RequestID"]+'\" class=\"ContentExtend startload dynamicButton btn-close-popup \" type=\"button\" disabled onclick=\"onclick_TruckButtonsDialogBox_LoadRequestStart(\'' + buttonTitle + '\',' + requestData["RequestID"] + ',' + requestTypeID +  '); return false;\"> ' + buttonTitle + ' Start </button >';
                 }
                 else {
                     htmlstring = '<button id=\"btnLoadStart'+ requestData["RequestID"]+'\"class=\"ContentExtend startload dynamicButton btn-loader btn-default\" type=\"button\" onclick=\"onclick_TruckButtonsDialogBox_LoadRequestStart(\'' + buttonTitle + '\','  + requestData["RequestID"] + ',' + requestTypeID +  '); return false;\"> ' + buttonTitle + ' Start </button >';
                 }
             }
             else {
                 var timeEnd = requestData["TimeRequestEnd"];
                 if (timeEnd) {
                 htmlstring = '<button id=\"btnLoadEnd'+ requestData["RequestID"]+'\"class="ContentExtend endload dynamicButton btn-close-popup \" type=\"button\" disabled onclick=\"onclick_TruckButtonsDialogBox_LoadRequestEnd(\'' + buttonTitle + '\',' +requestData["RequestID"]+  ',' + requestTypeID + '); return false;\"> ' + buttonTitle + ' End </button >';
                 }
                 else {
                     htmlstring = '<button id=\"btnLoadEnd'+ requestData["RequestID"]+'\"class=\"ContentExtend endload dynamicButton btn-loader btn-default\" type=\"button\" onclick=\"onclick_TruckButtonsDialogBox_LoadRequestEnd(\'' + buttonTitle + '\','  +requestData["RequestID"]+  ',' + requestTypeID + '); return false;\"> ' + buttonTitle + ' End </button >';
                 }
             }
             return htmlstring;
         }
         
         function onSuccess_completeRequest(value, ctx, methodName) {
                var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
                PageMethods.getLoadAndUnloadRequests(MSID, onSuccess_getLoadAndUnloadRequestsRefreshEnd, onFail_getLoadAndUnloadRequests);
         }

         function onFail_completeRequest(value, ctx, methodName) {
             
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_completeRequest");
         }


         function onSuccess_startRequest(value, ctx, methodName) {
                var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
                PageMethods.getLoadAndUnloadRequests(MSID, onSuccess_getLoadAndUnloadRequestsRefreshStart, onFail_getLoadAndUnloadRequests);
         }

         function onFail_startRequest(value, ctx, methodName) {
             
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_startRequest");
         }


        function refreshInspectionListDataAndbuttons() {
             $(".dynamicButton").remove();
             var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             var prodID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "ProdID");

             PageMethods.getInspectionList(MSID, prodID, onSuccess_getInspectionList, onFail_getInspectionList);
         }

         function onSuccess_getLoadAndUnloadRequests(value, ctx, methodName) {
             var requestID
             for (i = 0; i < value.length; i++) {
               
                 var htmlStart = getNewHTMLStringSurroundedByTag("<p>","</p>", getHTMLStringForLoadUnloadButton(value[i], true) )
                 $("#dvButtonsLoadUnload").append(htmlStart);
                 var htmlEnd = getNewHTMLStringSurroundedByTag("<p>","</p>",getHTMLStringForLoadUnloadButton(value[i], false) )
                 $("#dvButtonsLoadUnload").append(htmlEnd);
                 

             }

             createRejectButton();
             
             $("#TruckButtonsDialogBox").igDialog("open");
        }


         function createRejectButton() {

               var htmlReject = getNewHTMLStringSurroundedByTag("<p>","</p>", getHTMLStringForRejectTruck() )
                $("#dvButtonsRejectTruck").append(htmlReject);
         }

         function onSuccess_getLoadAndUnloadRequestsRefreshStart(value, ctx, methodName) {
             for (i = 0; i < value.length; i++) {
                 var requestID = value[i]["RequestID"]
                 $("#btnLoadStart" + requestID).parent().html(getHTMLStringForLoadUnloadButton(value[i], true))

             }
        }
         function onSuccess_getLoadAndUnloadRequestsRefreshEnd(value, ctx, methodName) {
             for (i = 0; i < value.length; i++) {
                 var requestID = value[i]["RequestID"]
                 $("#btnLoadEnd" + requestID).parent().html(getHTMLStringForLoadUnloadButton(value[i], false))
             }
        }

        function onFail_getLoadAndUnloadRequests() {
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_getLoadAndUnloadRequests");
        }

         function onSuccess_getInspectionList(value, ctx, methodName) {
             var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             if (value && value.length !== 0) {
                 var prodID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "ProdID");
                 var InspectionListID = value[0][0];
                 PageMethods.getMSInspectionListAndData(MSID, prodID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData);
             }
             else {
                PageMethods.getSampleInformationForMSID(MSID, onSuccess_getSampleInformationForMSID, onFail_getSampleInformationForMSID);
             }
             
             
         }

         function onFail_getInspectionList(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_getInspectionList");
         }

         function onSuccess_CheckInspectionValidationSetting(value, ctx, methodName) {
             
             var MSInspectionID = ctx["MSInspectionID"];
             var MSInspectionListID = ctx["MSInspectionListID"];
             var MSInspectionListDetailsID = ctx["MSInspectionListDetailsID"];

             if (value) {
                 var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
                var selectedProdDetailID = $('#loaderQuickGrid').igGrid("getCellValue", MSID, "PODetailsID");
                 PageMethods.canInspectionBeEdited(selectedProdDetailID, MSInspectionListID, MSInspectionID, onSuccess_canInspectionBeEdited, onFail_canInspectionBeEdited, ctx);
             }
             else {
                 openQuestionsDialog(MSInspectionListDetailsID,MSInspectionID, selectedInspectionListData);
             }
         }

         function onFail_CheckInspectionValidationSetting(value, ctx, methodName) { 
             sendtoErrorPage("Error in loaderMobile.aspx, onFail_CheckInspectionValidationSetting");
         }
         
         function onSuccess_canInspectionBeEdited(value, ctx, methodName) {
             if (!checkNullOrUndefined(value)) {
                 var canEdit = value[0];
                 var msg = value[1];

                 if (canEdit) {
                     var MSInspectionListDetailsID = ctx["MSInspectionListDetailsID"];
                     var MSInspectionID = ctx["MSInspectionID"];
                     var selectedInspectionListData = ctx["selectedInspectionListData"];

                     openQuestionsDialog(MSInspectionListDetailsID, MSInspectionID, selectedInspectionListData);
                 }
                 else {
                     if (!checkNullOrUndefined(msg)) {
                         alert(msg);
                     }
                     else {
                         alert("Inspection cannot be edited at this time");
                     }

                 }
             }

         }

         function onFail_canInspectionBeEdited(value, ctx, methodName) { 
             sendtoErrorPage("Error in loaderMobile.aspx, onFail_canInspectionBeEdited");
         }


         
         function checkIfValidationNeedsToBeDone(MSInspectionListDetailsID, MSInspectionID, MSInspectionListID, selectedInspectionListData) {
             
             var InspectionObject = {
                 "MSInspectionListDetailsID": MSInspectionListDetailsID,
                 "MSInspectionID": MSInspectionID,
                 "MSInspectionListID": MSInspectionListID,
                 "selectedInspectionListData": selectedInspectionListData
             };

             PageMethods.CheckInspectionValidationSetting(onSuccess_CheckInspectionValidationSetting, onFail_CheckInspectionValidationSetting, InspectionObject);
         }
         
         
         function openQuestionsDialog(MSInspectionListDetailsID,MSInspectionID, selectedInspectionListData) {
             populateQuestions(MSInspectionListDetailsID, selectedInspectionListData);
             $("TruckButtonsDialogBox").animate({ left: "+=250" });
            $("#dwInspectionQuestions").igDialog("open");
         }
         
         function getHTMLStringForInspections(msInspectionListObj ) {
             var inspectionObject = msInspectionListObj.MSInspection;
             var MSInspectionListDetailsID = msInspectionListObj.MSInspectionListDetailsID;
             var MSInspectionID = inspectionObject.MSInspectionID;
             var MSInspectionListID = msInspectionListObj.MSInspectionListID;
             var buttonTitle = inspectionObject["InspectionHeaderName"]; 
             var classString = "ContentExtend inspectionButton dynamicButton btn-loader btn-default ";
             if (inspectionObject["isFailed"]) {
                 classString = "ContentExtend inspectionButton dynamicButton btn-loader btn-default btn-warning"
             }
             else {
                 if (inspectionObject.InspectionEndEventID) //if not null then inspection ended
                 {
                     classString = "ContentExtend inspectionButton dynamicButton btn-close-popup"
                 }
             }

                 
             var stringDisabled = inspectionObject.InspectionEndEventID ? "disabled" : "";
            // .btn-warning;
                  htmlstring = '<button class=\" '+ classString + '\" type=\"button\" " onclick=\"checkIfValidationNeedsToBeDone('
                                + MSInspectionListDetailsID + "," 
                                 + MSInspectionID + "," 
                                 +  MSInspectionListID + "," 
                                + 'selectedInspectionListData);return false; \"> ' + buttonTitle + '</button >';
             return htmlstring;
         }

         function onSuccess_getMSInspectionListAndData(value, ctx, methodName) {

             if (value && value.length !== 0) {
                let insList = new InspectionList(value);
               // localStorage.setItem('InspectionListObject', JSON.stringify(insList));// Put the object into storage
                insList.copyInspectionListDetail(value.InspectionListDetails);
                selectedInspectionListData = getInspectionObjectFromMem.bind({ 'inspectionListData': insList });

                //insList.InspectionListDetails.forEach(
                //     function (inspectionDetail) {
                //        $("#dvButtons").append(getHTMLStringForInspections(inspectionDetail.MSInspection, inspectionDetail.MSInspectionListDetailsID));
                //     });
                 
                 $(".inspectionButton").remove();
                 for (var i = 0; i < insList.InspectionListDetails.length; i++) {
                     var msInspectionListObj = insList.InspectionListDetails[i];
                      var htmlInspection = getNewHTMLStringSurroundedByTag("<p>","</p>",getHTMLStringForInspections(msInspectionListObj) )
                     $("#dvButtonsInspections").append(htmlInspection);
                     
                 }
             
              //$("#TruckButtonsDialogBox").igDialog("open");
             }
             //else {
             // $("#TruckButtonsDialogBox").igDialog("open");
             //}
             
            var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
             PageMethods.getSampleInformationForMSID(MSID, onSuccess_getSampleInformationForMSID, onFail_getSampleInformationForMSID);
        }

             function onSuccess_getSampleInformationForMSID(value, ctx, methodName) {
                 var htmlSample = getNewHTMLStringSurroundedByTag("<p>","</p>", getHTMLStringForSample(value) )
                 $("#dvButtonsSample").append(htmlSample);
                var MSID = $("#TruckButtonsDialogBox").data("data-MSID");
                PageMethods.getLoadAndUnloadRequests(MSID, onSuccess_getLoadAndUnloadRequests, onFail_getLoadAndUnloadRequests);
             }
             
             function onFail_getSampleInformationForMSID(value, ctx, methodName) {
                    sendtoErrorPage("Error in loaderMobile.aspx, onFail_getSampleInformationForMSID");
             }  


         function getNewHTMLStringSurroundedByTag(openTag, closeTag, stringToSurround) {

             return openTag + stringToSurround + closeTag;
         }
         function getHTMLStringForSample(sampleData) {

                    <%--from request on 4/25 by mmitcham, remove disabling off button
                 //var timeSampleTaken = sampleData["TimeSampleTaken"];
                 //if (timeSampleTaken) {
                 //    return '<button class="ContentExtend dynamicButton disabled btn-close-popup" type="button" >Sample</button>';
                 //}
                 //else {
                     
                 //    return '<button class="ContentExtend dynamicButton btn-loader btn-default" onclick="onclick_TruckButtonsDialogBox_Sample(); return false; ">Sample</button>';
                     
                 //}--%>

            return '<button class="ContentExtend dynamicButton btn-loader btn-default" onclick="onclick_TruckButtonsDialogBox_Sample(); return false; ">Sample</button>';
                 
         }
         function getHTMLStringForRejectTruck() {
                return '<button class="ContentExtend dynamicButton btn-loader btn-default" onclick="onclick_TruckButtonsDialogBox_RejectTruck(); return false; ">Reject Truck</button>';
             }


         
         function onFail_getMSInspectionListAndData(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_getMSInspectionListAndData");
         }

         

         function onSuccess_getLoaderMobileGrid(value, ctx, methodName) {
            var gridData = [];
             for (i = 0; i < value.length; i++) {
                 var POnumber = value[i]["PONumber"]; 
                 if (value[i]["PONumber_ZXPOutbound"]) {
                     POnumber = POnumber + " - " +  value[i]["PONumber_ZXPOutbound"];
                 }
                 gridData[i] =
                 {
                     "MSID": value[i]["MSID"],
                     "StatusID": value[i]["StatusID"],
                     "SpotID": value[i]["SpotID"],
                     "LoadType": value[i]["LoadTypes"],
                     "ProdID": value[i]["ProductID_CMS"],
                     "ProdName": value[i]["ProductName_CMS"],
                     "SpotName": value[i]["SpotName"],
                     "StatusName": value[i]["StatusName"],
                     "Trailer": value[i]["TrailerNumber"],
                     "PODetailsID": value[i]["PODetailsID"],
                     "ETA":value[i]["ETA"],
                     "PONumber":POnumber
                     
                };
            }
            $("#loaderQuickGrid").igGrid("option", "dataSource", gridData);
             $("#loaderQuickGrid").igGrid("dataBind");
             
          //   var newRowWithButtons = '<tr><td><button class="ContentExtend">Inspection</button></td><td><button class="ContentExtend">Sample</button></td><td><button class="ContentExtend">Inspection</button></td>' + 
                //                '<td><button class="ContentExtend">Loading Start</button ></td><td><button class="ContentExtend">Loading End</button></td ></tr > '
           //  $('#loaderQuickGrid tbody>tr').after(newRowWithButtons);

         }

         function onFail_getLoaderMobileGrid(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderMobile.aspx, onFail_getLoaderMobileGrid");
        }

         

         $(function () {
            
             initGrid();
             PageMethods.getLoaderMobileGrid(onSuccess_getLoaderMobileGrid, onFail_getLoaderMobileGrid);
             initPopUps();
             InitInspectionQuestionOnclick();
             checkForRedirect();
         });
     </script>



<%-----------------------------------------------------------%>
<%--HTML SECTION--%>
<%-----------------------------------------------------------%>
     <div class="ContentExtend">
         
    <div class="dvGridFilterButtons">
        <button type="button" onclick='onclick_ClearGrid(); return false;'>Show All Trucks</button>
        <button type="button" onclick='onclick_ShowTodaysScheduledTrucks(); return false;'>Show Today's Trucks</button>
    </div>

         
         <br />
         <br />
        <table id="loaderQuickGrid" class="ContentExtend"></table>
    </div>



    <%-----------------------------------------------------------------------------------%>
    <%-- DIALOG/ POP UPS --%>
    <%-----------------------------------------------------------------------------------%>
    
    <%--Buttons Dialog--%>
    
    <div id ="TruckButtonsDialogBox" style="display:none">
            <%--<p><button class="ContentExtend btn-loader btn-default" onclick="onclick_TruckButtonsDialogBox_Sample(); return false;">Sample</button></p>--%>
            <div id="dvButtons">
                <div id="dvButtonsInspections"></div>
                <div id="dvButtonsSample"></div>
                <div id="dvButtonsLoadUnload"></div>
                <div id="dvButtonsRejectTruck"></div>
            </div>
         <p><button class="ContentExtend btn-close-popup" onclick="onclick_TruckButtonsDialogBox_Close(); return false;">Close Window</button></p>
    </div>

    
    <%--InspectionQuestions Dialog--%>
    <div id="dwInspectionQuestions" style="display:none">
            <div id="dvNavUp" class="dv_nav"><button class="btn_nav up_nav">Previous Question</button></div>
            <h3>Note: Answers are automatically saved.</h3> 
            <div class="dv_questionsArea">
                <div id="dvQuestionsArea"></div>
                <br /><br />
                <div><input type='button' value='Close Windows' onclick='closeIGDialog("dwInspectionQuestions")'/></div>
            </div>
            
            <div id="dvNavDown" class="dv_nav"><button class="btn_nav down_nav" >Next Question</button></div>
    </div>
</asp:Content>
