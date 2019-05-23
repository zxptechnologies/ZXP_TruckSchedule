<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="loaderTimeTracking.aspx.cs" Inherits="TransportationProject.loaderTimeTracking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Loader Requests</h2>
    <h3>Shows open loader requests and all completed requests for the day. </h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
        var data = [];
        var GLOBAL_UPDATE_DIALOG = false;
        var GLOBAL_IS_MOBILE_VIEWING = false;
        var GLOBAL_LOG_OPTIONS = [];
        var GLOBAL_COMPLETE_DATA = [];
        var GLOBAL_ISDIALOG_OPEN = false;


        <%-------------------------------------------------------
         Functions
         -------------------------------------------------------%>
        <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>
        function show_completeGrid() {
            $("#btn_hide_completeGrid").show();
            $("#btn_show_completeGrid").hide();
            $("#completeGridWrapper").show();
        }
        function hide_completeGrid() {
            $("#btn_show_completeGrid").show();
            $("#btn_hide_completeGrid").hide();
            $("#completeGridWrapper").hide();
        }
        function onClick_CloseFileDialog() {
            $("#dwFileUpload").igDialog("close")
        }

        function onclick_deleteFile(fid) {
            r = confirm("Continue removing this file from the truck data? This cannot be undone.")
            if (r) {
                var msid = $('#dwFileUpload').data("data-MSID");
                PageMethods.DeleteFileDBEntry(fid, "OTHER", msid, onSuccess_DeleteFileDBEntry, onFail_DeleteFileDBEntry, fid);
            }
        }
        function OnClick_AddImage(evt, msid, reqid) {
            $('#igUploadIMAGE').data("MSID", msid);
            $("#igUploadIMAGE_ibb_fp").click();
        }

        function onSuccess_ImageUpload(msid, reqid) {
            alert("Image Upload Successful ");
            //PageMethods.GetLogDataByMSID(msid, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, msid);
            $("#CameraUpload" + reqid).val("");
        }
        function onFailure_ImageUpload(reqid) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFailure_ImageUpload");
            $("#CameraUpload" + reqid).val("");
        }
        function chooseFile(reqid) {
            $("#CameraUpload" + reqid).click();
        }

        function onclick_btnSaveEditDialog() {
            var rowID = $("#editDialog").data("data-ReqID");
            var comments = $("#loaderCommentEditDialog").val();
            PageMethods.updateRequest(rowID, comments, onSuccess_updateRequest, onFail_updateRequest);
            $("#editDialog").igDialog("close");
        }

        function onclick_btnCancelEditDialog() {
            $("#POEditDialog").html(" ");
            $("#TrailerEditDialog").html(" ");
            $("#spotEditDialog").html(" ");
            $("#requestTypeEditDialog").html(" ");
            $("#taskCommentEditDialog").html(" ");
            $("#requestedByEditDialog").html(" ");
            $("#timeStartedEditDialog").html(" ");
            $("#timeEndedEditDialog").html(" ");
            $("#loaderCommentEditDialog").val(" ");
            $("#editDialog").igDialog("close");
        }

        function updateTotalGals() {
            var newTotal = parseFloat($("#iFtInGal").val()) + parseFloat($("#iFracGal").val());
            $("#iTTLGal").text(newTotal);
        }


        function onclick_startRequest(reqID, reqTypeID, MSID) {
            var data = [reqID, reqTypeID, MSID];
            if (reqTypeID == 2 || reqTypeID == 1) {
                PageMethods.checkIfTruckIsOnSite(MSID, onSuccess_checkIfTruckIsOnSite, onFail_checkIfTruckIsOnSite, data);
            }
            else {
                PageMethods.checkStatusOfRequest(reqID, onSuccess_checkStatusOfRequest, onFail_checkStatusOfRequest, data);
            }
        }
        function onclick_completeRequest(reqID, reqTypeID, MSID) {
            showProgress();
            PageMethods.completeRequest(reqID, reqTypeID, MSID, onSuccess_completeRequest, onFail_completeRequest, MSID);
        }
        function undoRequestStart(reqID, reqTypeID, MSID) {
            PageMethods.undoStartRequest(MSID, reqTypeID, reqID, onSuccess_undoStartRequest, onFail_undoStartRequest, MSID);
            $("#timeStartedUndoEditDialog").hide();
            $("#btnStrappingEndEditDialog").hide();
            $("#btnTimeEndedEditDialog").hide();
            $("#btnTimeStartedEditDialog").show();
            $("#timeStartedEditDialog").html("Time Started: ");
        }

        function undoRequestComplete(MSID, requestType) {
            PageMethods.undoCompleteRequest(MSID, requestType, onSuccess_undoCompleteRequest, onFail_undoCompleteRequest, MSID);
            $("#btnTimeEndedEditDialog").show();
            $("#btnStrappingEndEditDialog").show();
            $("#timeStartedUndoEditDialog").show();
            $("#timeEndedUndoEditDialog").hide();
            $("#timeEndedEditDialog").html("Time Ended: ");
        }
        function onclick_dialogButtonClick(buttonType, timeType) {
            var reqID = $("#editDialog").data("data-ReqID");
            var requestType = $("#grid").igGrid("getCellValue", reqID, "REQTYPEID");
            var MSID = $("#grid").igGrid("getCellValue", reqID, "MSID");
            switch (timeType) {
                case "start":
                    if (buttonType == "undo") {
                        undoRequestStart(reqID, requestType, MSID);
                    }
                    else if (buttonType == "moveFwd") {
                        onclick_startRequest(reqID, requestType, MSID);
                    }
                    else if (buttonType == "strap") {
                        startStrapping(MSID, true);
                    }

                    break;
                case "complete":
                    if (buttonType == "undo") {
                        undoRequestComplete(MSID, requestType);
                    }
                    else if (buttonType == "moveFwd") {
                        onclick_completeRequest(reqID, requestType, MSID);
                    }
                    else if (buttonType == "strap") {
                        endStrapping(MSID, false);
                    }
                    break;
            }

        }

        function startStrapping(MSID, isStart) {
            $("#lblTankStrappingDialog").data("isStart", isStart);
            $("#lblTankStrappingDialog").data("MSID", MSID);
            $("#lblTankStrappingDialog").text("Tank Strapping - Start");
            PageMethods.getTankStrapping(MSID, isStart, onSuccess_getTankStrapping, onFail_getTankStrapping);
        }
        function endStrapping(MSID, isStart) {
            $("#lblTankStrappingDialog").data("isStart", isStart);
            $("#lblTankStrappingDialog").data("MSID", MSID);
            $("#lblTankStrappingDialog").text("Tank Strapping - End");
            PageMethods.getTankStrapping(MSID, isStart, onSuccess_getTankStrapping, onFail_getTankStrapping);
        }
        function onclick_btnSaveStrap() {

            var MSID =$("#lblTankStrappingDialog").data("MSID");
            var isStart = $("#lblTankStrappingDialog").data("isStart");
            var tankStrap = {
                MSID: MSID,
                isStrapStart: isStart,
                TankNum: $("#iTankNum").val(),
                Temp: $("#iTemp").val(),
                Feet: $("#iFt").val(),
                Inches: $("#iInches").val(),
                GallonsConvertedFromFtAndIn: $("#iFtInGal").val(),
                Numerator: $("#iFracNum").val(),
                Denominator: $("#iFracDen").val(),
                GallonsConvertedFromFraction: $("#iFracGal").val(),
                GallonsTotal: parseFloat($("#iFtInGal").val()) + parseFloat($("#iFracGal").val()),
                Flush: $("#iFlush").val()
            };

            $("#lblTankStrappingDialog").data("MSID", null);
            $("#lblTankStrappingDialog").data("isStart", null);
            PageMethods.setTankStrapping(MSID, isStart, tankStrap, onSuccess_setTankStrapping, onFail_setTankStrapping)
        }
        function onSuccess_setTankStrapping() {
            
            $("#TankStrappingDialog").igDialog("close");
        }
        function onFail_setTankStrapping() {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_getTankStrapping");
            $("#TankStrappingDialog").igDialog("close");
        }
        function onclick_btnCancelStrap() {
            $("#lblTankStrappingDialog").data("MSID", null);
            $("#lblTankStrappingDialog").data("isStart", null);
            $("#TankStrappingDialog").igDialog("close");
        }

        function onSuccess_getTankStrapping(value, ctx, methodName) {

            $("#iTankNum").val(value["TankNum"]);
            $("#iTemp").val(value["Temp"]);
            $("#iFt").val(value["Feet"]);
            $("#iInches").val(value["Inches"]);
            $("#iFtInGal").val(value["GallonsConvertedFromFtAndIn"]);
            $("#iFracNum").val(value["Numerator"]);
            $("#iFracDen").val(value["Denominator"]);
            $("#iFracGal").val(value["GallonsConvertedFromFraction"]);
            $("#iTTLGal").val(value["GallonsTotal"]);
            $("#iFlush").val(value["Flush"]);

            $("#TankStrappingDialog").igDialog("open")
        }
        function onFail_getTankStrapping(value, ctx, methodName) {

            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_getTankStrapping");
        }

        function onSuccess_verifyIfInspectionIsDoneBeforeUnload(returnString, data, methodName) {
            if (checkNullOrUndefined(returnString) == true) {
                PageMethods.checkStatusOfRequest(data[0], onSuccess_checkStatusOfRequest, onFail_checkStatusOfRequest, data);
            }
            else {
                switch (returnString) {
                    case "hasNotStartedInspections":
                        alert("There are no inspections on record for this order. Inspections must be done before you can empty the trailer.")
                        break;
                    case "hasOpenInspections":
                        alert("This order still has open inspections. All inspections must be closed before you can empty the trailer.")
                        break;
                }
            }
        }

        function onFail_verifyIfInspectionIsDoneBeforeUnload(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_verifyIfInspectionIsDoneBeforeUnload");
        }

        function onclick_setAndRedirectToPatterns(REQID) {
            var MSID = $("#grid").igGrid("getCellValue", REQID, "MSID");
            var PO = $("#grid").igGrid("getCellValue", REQID, "PO");
            sessionStorage.setItem("MSID", MSID);
            sessionStorage.setItem("PO", PO);
            location.href = 'patternList.aspx';
        }


        function openProductDetailDialog(MSID, rowID) {
            if (MSID != -1) {
                var PO = $("#grid").igGrid("getCellValue", rowID, "PO");
                var trailer = $("#grid").igGrid("getCellValue", rowID, "TRAILER");
                var POTrailer = comboPOAndTrailer(PO, trailer);
                PageMethods.GetPODetailsFromMSID(MSID, onSuccess_GetPODetailsFromMSID, onFail_GetPODetailsFromMSID, MSID);
                if (POTrailer) {
                    $("#dvProductDetailsPONUM").text(POTrailer);
                }

            }
        }
        function checkForRedirect() {
            
            var url_string = window.location.href;
            var url = new URL(url_string);
            var MSIDRedirect = url.searchParams.get("MSID");
            if (MSIDRedirect) {
                $("#grid").igGridFiltering("filter", ([{
                                fieldName: "MSID",
                                expr: MSIDRedirect,
                                cond: "equals"
                            }]), true);

            }

        }

        <%-------------------------------------------------------
         Pagemethods Handlers
         -------------------------------------------------------%>
        function onSuccess_checkIfTruckIsOnSite(isOnSite, reqData, methodName) {
            var MSID = reqData[2];
            var reqTypeID = reqData[1];
            var reqID = reqData[0];
            var canContinue = false;

            if (isOnSite == false) {
                var PO = $("#grid").igGrid("getCellValue", reqID, "PO");

                var c = confirm("The current PO: " + PO + " is not on site. Would you like to continue with the request?");
                if (c == true) {
                    canContinue = true;
                }
            }
            else {
                canContinue = true;
            }

            if (canContinue == true) {
                if (reqTypeID == 2) {
                    PageMethods.verifyIfInspectionIsDoneBeforeUnload(MSID, onSuccess_verifyIfInspectionIsDoneBeforeUnload, onFail_verifyIfInspectionIsDoneBeforeUnload, reqData);
                }

                else {
                    PageMethods.checkStatusOfRequest(reqID, onSuccess_checkStatusOfRequest, onFail_checkStatusOfRequest, reqData);
                }
            }
            else {
                $("#grid").igGrid("rollback", reqID, true);
            }
        }

        function onFail_checkIfTruckIsOnSite(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_checkIfTruckIsOnSite");
        }



        function onSuccess_GetPODetailsFromMSID(value, ctx, methodName) {

            var gridData = [];
            for (i = 0; i < value.length; i++) {
                gridData[i] = {
                    "PODETAILID": value[i][0], "CMSPROD": value[i][1], "QTY": value[i][2], "LOT": value[i][3], "UNIT": value[i][4], "CMSPRODNAME": value[i][5]
                };
            }
            $("#gridPODetails").igGrid("option", "dataSource", gridData);
            $("#gridPODetails").igGrid("dataBind");
            $("#dwProductDetails").igDialog("open");

        }

        function onFail_GetPODetailsFromMSID(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_GetPODetailsFromMSID");
        }
        function onSuccess_getLoaderTimeTrackingGridData(value, ctx, methodName) {
            var newLoaderTimeTrackingData = [];   <%--values to bind grid--%>
            newLoaderTimeTrackingData.length = 0; <%--make empty--%>

            for (i = 0; i < value.length; i++) {
                var loadername = null;
                var requester = value[i][13] + " " + value[i][14];
                var ospotDesc = formatValueToValueOrNoneWithParenthesis(value[i][10]);
                var currentSpotDesc = formatValueToValueOrNoneWithParenthesis(value[i][24]);

                var poLabel = formatValueToValueOrNA(value[i][1]);
                var isOpenInCMS;
                isOpenInCMS = formatBoolAsYesOrNO(value[i][22]);

                if (!checkNullOrUndefined(value[i][11])) {
                    loadername = value[i][11] + " " + value[i][12];
                }
                newLoaderTimeTrackingData[i] = {
                    "MSID": value[i][0], "PO": poLabel, "REQID": value[i][2], "TASK": value[i][3], "LOADERID": value[i][4], "REQUESTERID": value[i][5],
                    "COMMENTS": value[i][6], "PERSONTYPEID": value[i][7], "REQTYPEID": value[i][8], "REQTYPENAME": value[i][18],
                    "SPOT": [i][9], "SPOTDESC": ospotDesc, "LOADERNAME": loadername, "REQUESTERNAME": requester,
                    "TIMEASSIGNED": value[i][15], "TSTART": value[i][16], "TEND": value[i][17], "TDUE": value[i][19],
                    "REJECT": value[i][20], "TRAILER": value[i][21], "PATTERNS": "",
                    "isOpenInCMS": isOpenInCMS, "CURRENTSPOT": value[i][25], "CURRENTSPOTDESC": currentSpotDesc, "PRODCOUNT": value[i][25], "PRODID": value[i][26], "PRODDETAIL": value[i][27]
                };
            }
            $("#grid").igGrid("option", "dataSource", newLoaderTimeTrackingData);
            $("#grid").igGrid("dataBind"); <%--rebind --%>

            PageMethods.getCompletedRequestData(onSuccess_getCompletedRequestData, onFail_getCompletedRequestData);
            if (ctx != null) {
                //PageMethods.GetLogDataByMSID(ctx, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ctx);
            }
        }
        function onFail_getLoaderTimeTrackingGridData(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_getLoaderTimeTrackingGridData");
        }

        function onSuccess_startRequest(value, ctx, methodName) {
            if (value) {
                $("#btnTimeStartedEditDialog").hide();
                $("#timeStartedUndoEditDialog").show();
                $("#btnTimeEndedEditDialog").show();
                $("#btnStrappingEndEditDialog").show();
                $("#timeStartedEditDialog").html("Time Started: " + formatDate(value));
            }
             <%--refresh grid --%>
             PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData, ctx);
         }

         function onFail_startRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_startRequest");
         }

         function onSuccess_completeRequest(value, ctx, methodName) {
             hideProgress();
             if (value) {
                 $("#timeStartedUndoEditDialog").hide();
                 $("#timeEndedUndoEditDialog").show();
                 $("#btnTimeEndedEditDialog").hide();
                 $("#btnStrappingEndEditDialog").hide();
                 $("#timeEndedEditDialog").html("Time Ended: " + formatDate(value));
             }
             <%--refresh grid --%>
             PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData);
             //PageMethods.GetLogDataByMSID(ctx, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ctx);
         }

         function onFail_completeRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_completeRequest");
         }

         function onSuccess_updateRequest(value, ctx, methodName) {
             <%--refresh grid --%>
             PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData);
         }

         function onFail_updateRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_updateRequest");
         }

         function onSuccess_undoStartRequest(value, ctx, methodName) {
             <%--refresh grid --%>
             PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData, ctx);
         }
         function onFail_undoStartRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_undoStartRequest");
         }

         function onSuccess_undoCompleteRequest(value, ctx, methodName) {
             <%--refresh grid --%>
             PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData);
         }
         function onFail_undoCompleteRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_undoCompleteRequest");
         }
         function onSuccess_GetLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }
         function onFail_GetLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx onFail_GetLogDataByMSID");
         }

        function onSuccess_GetLogList(value, ctx, methodName) {
            GLOBAL_LOG_OPTIONS = [];
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailer = comboPOAndTrailer($.trim(value[i][1]), $.trim(value[i][2]));
                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailer });
                 }
                 $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                 $("#cboxLogTruckList").igCombo("dataBind");
             }
         }

         function onFail_GetLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx onFail_GetLogList");
         }

         function onSuccess_getCompletedRequestData(gridData, ctx, methodName) {
             if (gridData) {
                 var requester = "";
                 var assignee = null;
                 for (i = 0; i < gridData.length; i++) {
                     requester = gridData[i][4] + " " + gridData[i][5];
                     var poLabel;
                     if (-1 === gridData[i][0]) {
                         poLabel = "(N/A)";
                     }
                     else {
                         poLabel = gridData[i][1];
                     }
                     var trailernum = formatValueToValueOrNA(gridData[i][13]);
                     var nspotDesc = formatValueToValueOrNA(gridData[i][12]);

                     var isOpenInCMS;
                     isOpenInCMS = formatBoolAsYesOrNO(gridData[i][17]);

                     if (!checkNullOrUndefined(gridData[i][6])) {
                         assignee = gridData[i][6] + " " + gridData[i][7];
                     }
                     GLOBAL_COMPLETE_DATA[i] = {
                         "MSID": gridData[i][0], "PO": poLabel, "REQID": gridData[i][2], "TASK": gridData[i][3], "REQUESTER": requester, "ASSIGNEE": assignee,
                         "TIMEASSIGNED": gridData[i][8], "TSTART": gridData[i][9], "TEND": gridData[i][10], "COMMENTS": gridData[i][11], "NEWSPOT": nspotDesc,
                         "TRAILNUM": gridData[i][13], "DUETIME": gridData[i][14], "REJECT": gridData[i][16], "isOpenInCMS": isOpenInCMS
                     };
                 }
                 $("#completedGrid").igGrid("option", "dataSource", GLOBAL_COMPLETE_DATA);
                 $("#completedGrid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
                 checkForRedirect();
             }
         }

         function onFail_getCompletedRequestData(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_getCompletedRequestData");
         }


         function onSuccess_checkStatusOfRequest(value, startRequestRequiredData, methodName) {<%--startRequestRequiredData = [reqID, reqTypeID, MSID];--%>
             if (value) {
                 if (value[1] == 1) { <%--isAvailableForUserToEdit--%>
                     PageMethods.startRequest(startRequestRequiredData[0], startRequestRequiredData[1], startRequestRequiredData[2], onSuccess_startRequest, onFail_startRequest, startRequestRequiredData[2]);
                 }
                 else {
                     if (value[0] == 0) { <%--doesRequestExist--%>
                         alert("Request is no longer available.");
                     }
                     else {
                         alert("Request is assigned to another user.");
                     }
                 }
             }
         }

         function onFail_checkStatusOfRequest(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx onFail_checkStatusOfRequest");
         }
         function onSuccess_GetFileUploadsFromMSID(value, MSID, methodName) {
            <%--clear data from controls --%>
             $('#alinkBOL').text("");
             $('#alinkCOFA').text("");
             $('#dUpBOL').show();
             $('#dDelBOL').hide();
             $('#dUpCOFA').show();
             $('#dDelCOFA').hide();

             var rowID = $('#dwFileUpload').data("data-rowID");
             if (value.length > 0) {
                 var gridData = [];
                 var rowCount = 0;
                 for (var i = 0; i < value.length; i++) {
                     gridData[i] = { "FID": value[i][0], "MSID": value[i][1], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5], "FNAMEOLD": value[i][6], "FUPDEL": "" };
                 }
                 $("#gridFiles").igGrid("option", "dataSource", gridData);
                 $("#gridFiles").igGrid("dataBind");
             }

             var PO = $("#grid").igGrid("getCellValue", rowID, "PO");
             var trailer = $("#grid").igGrid("getCellValue", rowID, "TRAILER");
             var POTrailer = comboPOAndTrailer(PO, trailer);

             if (POTrailer) {
                 $("#POTrailer_dwFileUpload").text(POTrailer);
             }
             $("#dwFileUpload").igDialog("open");
         }

         function onFail_GetFileUploadsFromMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_GetFileUploadsFromMSID");
         }
         function openUploadDialog(MSID, REQID) {
             $('#dwFileUpload').data("data-MSID", MSID);
             $('#dwFileUpload').data("data-rowID", REQID);
             PageMethods.GetFileUploadsFromMSID(MSID, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, MSID);
         }
         function openUploadDialogMobile(MSID, REQID) {
             $("#gridFiles").igGridUpdating("option", "enableAddRow", false);
             $('#dwFileUpload').data("data-MSID", MSID);
             $('#dwFileUpload').data("data-rowID", REQID);
             PageMethods.GetFileUploadsFromMSID(MSID, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, MSID);
         }
         function onSuccess_ProcessFileAndData(value, FileInfo, methodName) {
             if (FileInfo) {
                 var fileuploadType = FileInfo[1];
                 if ("IMAGE" === fileuploadType) {
                     //Add entry into DB 
                     var timestamp = new Date().toLocaleDateString();
                     var imageDescription = "Loader Uploaded Image " + timestamp;
                     PageMethods.AddFileDBEntry(FileInfo[2], "IMAGE", FileInfo[0], value[1], value[0], imageDescription, onSuccess_AddFileDBEntry, onFail_AddFileDBEntry, FileInfo)
                 }
                 else if ("OTHER" === fileuploadType) {
                    <%--Add OTHER filetype entry into db only happens on add row finished because need to get Detail column--%>
                    <%--add attributes related to grid for use when adding new row --%>
                     $("#gridFiles").data("data-FPath", value[0]);
                     $("#gridFiles").data("data-FNameNew", value[1]);
                     $("#gridFiles").data("data-FNameOld", FileInfo[0]);

                    <%--change text of add new row's filename column to uploaded file's original name --%>
                    $("#dwFileUpload tr[data-new-row='true']").find("td.ui-iggrid-editingcell:first").text(FileInfo[0]);
                 }
             }
         }

         function onFail_ProcessFileAndData(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_ProcessFileAndData");
         }
         function onSuccess_AddFileDBEntry(value, ctx, methodName) {
             var msid = $('#dwFileUpload').data("data-MSID");
             if (!checkNullOrUndefined(msid)) {
                 PageMethods.GetFileUploadsFromMSID(msid, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, msid);
             }
         }

         function onFail_AddFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_AddFileDBEntry");
         }

         function onSuccess_UpdateFileUploadData(value, ctx, methodName) {
            <%--Success do nothing --%>
            $("#gridFiles").igGrid("commit");
        }

        function onFail_UpdateFileUploadData(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_UpdateFileUploadData");
        }

        function onSuccess_DeleteFileDBEntry(value, rowID, methodName) {
            $("#gridFiles").igGridUpdating("deleteRow", rowID);
            $("#gridFiles").igGrid("commit");
            var msid = $('#dwFileUpload').data("data-MSID");
            PageMethods.GetFileUploadsFromMSID(msid, onSuccess_GetFileUploadsFromMSID, onFail_GetFileUploadsFromMSID, msid);
        }

        function onFail_DeleteFileDBEntry(value, ctx, methodName) {
            sendtoErrorPage("Error in loaderTimeTracking.aspx, onFail_DeleteFileDBEntry");
        }
         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>

        $(function () {

            $(".arrowGridScrollButtons").show();
            $("#btn_show_completeGrid").hide();
            $("#btnViewTruck").hide();
            var GLOBAL_IS_MOBILE_VIEWING = isOnMobile();
            if (GLOBAL_IS_MOBILE_VIEWING == false) {
                $("#logButton").click(function () {
                    var logDisplay = $('#logTableWrapper').css('display');
                    truckLog_MiniMaxAndRemember(logDisplay);
                });
            }


            var textAreaWidth = getWidthForTextAreaForMobilePopUp();
            $("#loaderCommentEditDialog").css({ "width": textAreaWidth });


            $("#cboxLogTruckList").igCombo({
                dataSource: GLOBAL_LOG_OPTIONS,
                textKey: "PO",
                valueKey: "MSID",
                width: "100%",
                virtualization: true,
                selectionChanged: function (evt, ui) {
                    if (ui.items.length == 1) {
                        //PageMethods.GetLogDataByMSID(ui.items[0].data.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, ui.items[0].data.MSID);
                    }
                    else if (ui.items.length == 0) {
                        $("#tableLog").empty();
                    }
                }
            });

            //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);
            if (GLOBAL_IS_MOBILE_VIEWING) {
                hide_completeGrid();
                $("#grid").igGrid({
                    dataSource: data,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    renderCheckboxes: true,
                    primaryKey: "REQID",
                    columns:
                    [
                        { headerText: "", key: "REQID", dataType: "number", width: "0%", hidden: true },
                        { headerText: "", key: "SPOT", dataType: "number", width: "0%", hidden: true },
                        { headerText: "", key: "REQTYPEID", dataType: "number", width: "0%", hidden: true },
                        {
                            headerText: "Image Upload", key: "IMGUP", dataType: "text", width: "10%", template:
                            "<img id = 'CameraImg' src ='Images/camera48x48.png' style='width:75%; height: auto;' onclick='GLOBAL_ISDIALOG_OPEN = true; OnClick_AddImage(event,${MSID}, ${REQID}); return false;'/>"
                        },
                        {
                            headerText: "Files", key: "FUPLOAD", dataType: "string", template: "{{if(${MSID} !== -1)}} " +
                            "<div><input type='button' value='View' onclick='GLOBAL_ISDIALOG_OPEN = true; openUploadDialogMobile(${MSID}, ${REQID}); return false;'></div>" +
                            "{{else}} <div>(N/A)</div>{{/if}}", width: "0%", hidden: true
                        },
                        {
                            headerText: "Rejected", key: "REJECT", dataType: "boolean", template: "{{if(${REJECT})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "0%", hidden: true
                        },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0%", hidden: true },
                        {
                            headerText: "MSID", key: "MSID", dataType: "number", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}", width: "0%", hidden: true
                        },
                        { headerText: "PO", key: "PO", dataType: "string", width: "18%" },
                        {
                            headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "18%", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${TRAILER}</div>{{/if}}"
                        },
                        { headerText: "Spot", key: "SPOTDESC", dataType: "string", width: "0%", hidden: true },
                        { headerText: "", key: "CURRENTSPOT", dataType: "number", width: "0%", hidden: true },
                        { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", hidden: true, width: "0%" },
                        {
                            headerText: "Product", key: "PRODID", dataType: "string", width: "18%",
                            template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                            "{{else}}Multiple{{/if}}"
                        },
                        { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0%", hidden: true },
                        {
                            headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "18%",
                            template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                            "{{else}}<div><input type='button' value='Multiple' onclick='GLOBAL_ISDIALOG_OPEN = true; openProductDetailDialog(${MSID},${REQID}); return false;'></div>{{/if}}"
                        },

                        { headerText: "Request Type", key: "REQTYPENAME", dataType: "string", width: "0%", hidden: true },
                        { headerText: "Task Comments", key: "TASK", dataType: "string", width: "0%", hidden: true },
                        { headerText: "Assigned to", key: "LOADERNAME", dataType: "string", width: "18%" },
                        { headerText: "Requested by", key: "REQUESTERNAME", dataType: "string", width: "0%", hidden: true },
                        { headerText: "Time Due", key: "TDUE", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                        {
                            headerText: "Time Started", key: "TSTART", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true
                        },
                        {
                            headerText: "Time End", key: "TEND", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true
                        },

                        { headerText: "Loader Comments", key: "COMMENTS", dataType: "string", width: "0%", hidden: true },
                        {
                            headerText: "Patterns", key: "Patterns", width: "0%", hidden: true,
                            template: "<input id=${MSID}_btnPatterns type='button' value='Patterns' onclick = GLOBAL_ISDIALOG_OPEN = true; onclick_setAndRedirectToPatterns(${REQID}) return false;'>"
                        },

                    ],
                    features: [
                        {
                            name: 'Paging'
                        },
                        {
                            name: 'Resizing'
                        },
                        {
                            name: 'Updating',
                            enableAddRow: false,
                            editMode: "row",
                            enableDeleteRow: false,
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            editRowStarting: function (evt, ui) {
                                var isUploadBtnClicked = $("#grid").data("data-BUTTONClick");
                                if (isUploadBtnClicked) {
                                    $("#grid").data("data-BUTTONClick", false);
                                    return false;
                                }
                                $("#editDialog").data("data-ReqID", ui.rowID);
                                if (!ui.rowAdding) {
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);

                                    if (row.MSID !== -1) {
                                        $("#btnViewFiles").removeAttr('disabled');
                                        $("#btnViewFiles").click(function () { GLOBAL_ISDIALOG_OPEN = true; openUploadDialogMobile(row.MSID, row.REQID); });

                                        $("#btnViewPatterns").removeAttr('disabled');
                                        $("#btnViewPatterns").click(function () { GLOBAL_ISDIALOG_OPEN = true; onclick_setAndRedirectToPatterns(row.REQID) });
                                    }
                                    else {
                                        $("#btnViewFiles").attr("disabled", "disabled");
                                        $("#btnViewPatterns").attr("disabled", "disabled");
                                    }
                                    if (row.REJECT) {
                                        $("#RejectEditDialog").html("Rejected");
                                    }
                                    else {
                                        $("#RejectEditDialog").html("");
                                    }
                                    $("#POEditDialog").html(row.PO);
                                    $("#TrailerEditDialog").html(row.TRAILER);
                                    if (row.SPOTDESC != null) {
                                        $("#spotEditDialog").html(row.SPOTDESC);
                                    }
                                    else { $("#spotEditDialog").html(" "); }

                                    if (row.REQTYPENAME != null) {
                                        $("#requestTypeEditDialog").html(row.REQTYPENAME);
                                    }
                                    else { $("#requestTypeEditDialog").html(" "); }

                                    if (row.TASK != null) {
                                        $("#taskCommentEditDialog").html(row.TASK);
                                    }
                                    else { $("#taskCommentEditDialog").html(" "); }

                                    if (row.TASK != null) {
                                        $("#requestedByEditDialog").html(row.REQUESTERNAME);
                                    }
                                    else { $("#requestedByEditDialog").html(" "); }
                                    if (checkNullOrUndefined(row.TSTART) == false) {
                                        $("#timeStartedEditDialog").html(formatDate(row.TSTART));
                                    }

                                    if (checkNullOrUndefined(row.TEND) == false) {
                                        $("#timeEndedEditDialog").html(formatDate(row.TEND));
                                    }
                                    if (row.TSTART == null && row.TEND == null) {
                                        $("#timeStartedEditDialog").html(" ");
                                        $("#btnTimeStartedEditDialog").show();
                                        $("#timeStartedUndoEditDialog").hide();

                                        $("#timeEndedEditDialog").html(" ");
                                        $("#btnTimeEndedEditDialog").hide();
                                        $("#btnStrappingEndEditDialog").hide();
                                        $("#timeEndedUndoEditDialog").hide();

                                        $("#loaderCommentEditDialog").html(row.COMMENTS);
                                        if (GLOBAL_ISDIALOG_OPEN === false) {
                                            $("#editDialog").igDialog("open");
                                        }
                                        else {
                                            GLOBAL_ISDIALOG_OPEN = false;
                                        }
                                        return false;

                                    }
                                    else if (row.TSTART != null && row.TEND == null) {
                                        $("#timeStartedEditDialog").html(formatDate(row.TSTART));
                                        $("#btnTimeStartedEditDialog").hide();
                                        $("#timeStartedUndoEditDialog").show();

                                        $("#timeEndedEditDialog").html(" ");
                                        $("#btnTimeEndedEditDialog").show();
                                        $("#btnStrappingEndEditDialog").show();
                                        $("#timeEndedUndoEditDialog").hide();

                                        $("#loaderCommentEditDialog").html(row.COMMENTS);
                                        if (GLOBAL_ISDIALOG_OPEN === false) {
                                            $("#editDialog").igDialog("open");
                                        }
                                        else {
                                            GLOBAL_ISDIALOG_OPEN = false;
                                        }
                                        return false;
                                    }
                                    else if (row.TSTART != null && row.TEND != null) {
                                        $("#timeStartedEditDialog").html(formatDate(row.TSTART));
                                        $("#btnTimeStartedEditDialog").hide();
                                        $("#timeStartedUndoEditDialog").hide();

                                        $("#timeEndedEditDialog").html(formatDate(row.TEND));
                                        $("#btnTimeEndedEditDialog").hide();
                                        $("#btnStrappingEndEditDialog").hide();
                                        $("#timeEndedUndoEditDialog").show();

                                        $("#loaderCommentEditDialog").html(row.COMMENTS);
                                        if (GLOBAL_ISDIALOG_OPEN === false) {
                                            $("#editDialog").igDialog("open");
                                        }
                                        else {
                                            GLOBAL_ISDIALOG_OPEN = false;
                                        }
                                        return false;
                                    }
                                }
                            },
                            editRowEnding: function (evt, ui) {
                                if (!ui.rowAdding) {
                                    var origEvent = evt.originalEvent;
                                    if (typeof origEvent === "undefined") {
                                        ui.keepEditing = true;
                                        return false;
                                    }
                                    if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {

                                        if (origEvent.type !== "click") {
                                            ui.keepEditing = true;
                                        }
                                        return false;
                                    }
                                    else {
                                        var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                        PageMethods.updateRequest(row.REQID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                                    }
                                }
                            },
                            columnSettings:
                            [
                                { columnKey: "FUPLOAD", readOnly: true },
                                { columnKey: "isOpenInCMS", readOnly: true },
                                { columnKey: "REQID", readOnly: true },
                                { columnKey: "SPOT", readOnly: true },
                                { columnKey: "PO", readOnly: true },
                                { columnKey: "TRAILER", readOnly: true },
                                { columnKey: "PRODCOUNT", readOnly: true },
                                { columnKey: "PRODID", readOnly: true },
                                { columnKey: "PRODDETAIL", readOnly: true },
                                { columnKey: "IMGUP", readOnly: true },
                                { columnKey: "REJECT", readOnly: true },
                                { columnKey: "SPOTDESC", readOnly: true },
                                { columnKey: "REQTYPENAME", readOnly: true },
                                { columnKey: "TASK", readOnly: true },
                                { columnKey: "LOADERNAME", readOnly: true },
                                { columnKey: "REQUESTERNAME", readOnly: true },
                                { columnKey: "TDUE", readOnly: true },
                                { columnKey: "TSTART" },
                                { columnKey: "TEND" },
                                { columnKey: "PATTERNS", readOnly: true },
                                {
                                    columnKey: "COMMENTS",
                                    editorType: "text",
                                    editorOptions: {
                                        maxLength: 250
                                    }
                                },
                            ]
                        },
                        {
                            name: 'Sorting'
                        },
                        {
                        name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                            columnSettings: [{ columnKey: "FUPLOAD", allowFiltering: false },
                                { columnKey: "MSID", allowFiltering: true },
                                { columnKey: "isOpenInCMS", allowFiltering: false },
                                { columnKey: "REQID", allowFiltering: false },
                                { columnKey: "SPOT", allowFiltering: false },
                                { columnKey: "PO", allowFiltering: false },
                                { columnKey: "TRAILER", allowFiltering: false },
                                { columnKey: "PRODCOUNT", allowFiltering: false },
                                { columnKey: "PRODID", allowFiltering: false },
                                { columnKey: "PRODDETAIL", allowFiltering: false },
                                { columnKey: "IMGUP", allowFiltering: false },
                                { columnKey: "REJECT", allowFiltering: false },
                                { columnKey: "SPOTDESC", allowFiltering: false },
                                { columnKey: "REQTYPENAME", allowFiltering: false },
                                { columnKey: "TASK", allowFiltering: false },
                                { columnKey: "LOADERNAME", allowFiltering: false },
                                { columnKey: "REQUESTERNAME", allowFiltering: false },
                                { columnKey: "TDUE", allowFiltering: false },
                                { columnKey: "TSTART" , allowFiltering: false },
                                { columnKey: "TEND" , allowFiltering: false },
                                { columnKey: "PATTERNS", allowFiltering: false },
                                { columnKey: "COMMENTS", allowFiltering: false }

                            ]
                        }
                    ]

                }); <%--end of $("#grid").igGrid({--%>
                $("#completedGrid").igGrid({
                    dataSource: GLOBAL_COMPLETE_DATA,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    renderCheckboxes: true,
                    primaryKey: "REQID",
                    columns:
                    [

                        {
                            headerText: "Rejected", key: "REJECT", dataType: "boolean", template: "{{if(${REJECT})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "10%"
                        },
                        { headerText: "Is open in CMS", key: "isOpenInCMS", width: "0%", hidden: true },
                        { headerText: "", key: "REQID", dataType: "number", width: "0%", hidden: true, readOnly: true },
                        {
                            headerText: "MSID", key: "MSID", dataType: "string", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}", width: "0%", hidden: true
                        },
                        { headerText: "PO", key: "PO", dataType: "string", width: "16%" },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "16%" },
                        { headerText: "New Spot (If Applicable)", key: "NEWSPOT", dataType: "string", width: "12%" },
                        { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "0%", hidden: true },
                        { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "0%", hidden: true },
                        { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                        { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                        { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                        { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0%", hidden: true },
                        { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "16%" },
                        { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "29%" },
                    ],
                    features: [
                        {
                            name: 'Paging'
                        },
                        {
                            name: 'Resizing'
                        },
                        {
                            name: 'Updating',
                            enableAddRow: false,
                            editMode: "row",
                            enableDeleteRow: false,
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            columnSettings:
                            [
                                { columnKey: "isOpenInCMS", readOnly: true },
                                { columnKey: "MSID", readOnly: true },
                                { columnKey: "PO", readOnly: true },
                                { columnKey: "MSID", readOnly: true },
                                { columnKey: "REQID", readOnly: true },
                                { columnKey: "TASK", readOnly: true },
                                { columnKey: "REQUESTER", readOnly: true },
                                { columnKey: "ASSIGNEE", readOnly: true },
                                { columnKey: "TIMEASSIGNED", readOnly: true },
                                { columnKey: "TSTART", readOnly: true },
                                { columnKey: "TEND", readOnly: true },
                                { columnKey: "COMMENTS", readOnly: true },
                                { columnKey: "NEWSPOT", readOnly: true },
                                { columnKey: "TRAILNUM", readOnly: true },
                                { columnKey: "NEWSPOT", readOnly: true },
                                { columnKey: "REJECT", readOnly: true },
                                { columnKey: "DUETIME", readOnly: true }
                            ]
                        },
                    ]

                }); <%--end complete grid--%>


                $("#gridPODetails").igGrid({
                    dataSource: null,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    primaryKey: "PODETAILID",
                    columns:
                    [
                        { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                        { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "34%", },
                        { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "34%", },
                        { headerText: "QTY", key: "QTY", dataType: "number", width: "16%", },
                        { headerText: "Unit", key: "UNIT", dataType: "string", width: "16%", }
                    ]
                });
            }
            else {

                GLOBAL_IS_MOBILE_VIEWING = false;
                $("#dvHideShowButtons").hide();
                $("#grid").igGrid({
                    dataSource: data,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    renderCheckboxes: true,
                    primaryKey: "REQID",
                    columns:
                    [
                        { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "SPOT", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "REQTYPEID", dataType: "number", width: "0px", hidden: true },
                        {
                            headerText: "Image Upload", key: "IMGUP", dataType: "text", width: "60px", template:
                            "<img id = 'CameraImg' src ='Images/camera48x48.png' onclick='OnClick_AddImage(event,${MSID}, ${REQID}); return false;'/>"
                        },
                        {
                            headerText: "File Upload", key: "FUPLOAD", dataType: "string", width: "100px", template: "{{if(${MSID} !== -1)}} " +
                            "<div><input type='button' value='View/Upload' onclick='openUploadDialog(${MSID}, ${REQID}); return false;'></div>" +
                            "{{else}} <div>(N/A)</div>{{/if}}"
                        },
                        {
                            headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                        },
                        {
                            headerText: "Is open in CMS", key: "isOpenInCMS", width: "0px", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${isOpenInCMS}</div>{{/if}}"
                        },
                        {
                            headerText: "MSID", key: "MSID", dataType: "number", width: "0px", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                        },
                        {
                            headerText: "PO / Patterns", key: "PO", dataType: "string", width: "90px",
                            template: "{{if(${MSID} == -1)}}<div>(N/A)</div>{{else}}<div class ='ColumnContentExtend'><div class=\"tooltip\"> <input id=${MSID}_btnPatterns type='button' value=${PO} onclick = onclick_setAndRedirectToPatterns(${REQID})><span class=\"tooltiptext\">Patterns</span><\div></div>{{/if}}"
                        },
                        {
                            headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "100px", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${TRAILER}</div>{{/if}}"
                        },
                        { headerText: "Originally Assigned Spot", key: "SPOTDESC", dataType: "string", width: "75px" },
                        { headerText: "Current Spot", key: "CURRENTSPOTDESC", dataType: "string", width: "75px" },
                        { headerText: "Request Type", key: "REQTYPENAME", dataType: "string", width: "90px" },
                        {
                            headerText: "Product", key: "PRODID", dataType: "string", width: "150px",
                            template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODID}</div>" +
                            "{{else}}Multiple{{/if}}"
                        },
                        { headerText: "", key: "PRODCOUNT", dataType: "number", width: "0px", hidden: true },
                        {
                            headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px",
                            template: "{{if(${PRODCOUNT} == 0 )}} N/A " +
                            "{{elseif (${PRODCOUNT} < 2)}}<div>${PRODDETAIL}</div>" +
                            "{{else}}<div><input type='button' value='Multiple' onclick='openProductDetailDialog(${MSID},${REQID}); return false;'></div>{{/if}}"
                        },
                        { headerText: "Task Comments", key: "TASK", dataType: "string", width: "200px" },
                        { headerText: "Assigned to", key: "LOADERNAME", dataType: "string", width: "125px" },
                        { headerText: "Requested by", key: "REQUESTERNAME", dataType: "string", width: "100px" },
                        { headerText: "Time Due", key: "TDUE", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                        {
                            headerText: "Time Started", key: "TSTART", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                            template: "{{if(checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'><input id='btnReqStart' type='button' value='Start' onclick='onclick_startRequest(${REQID}, ${REQTYPEID}, ${MSID});' class='ColumnContentExtend'/></div>" +
                            "{{elseif (checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'>${TSTART}<span class='Mi4_undoIcon' onclick='undoRequestStart(${REQID}, ${REQTYPEID}, ${MSID});'></span></div>" +
                            "{{else}}${TSTART}</div>{{/if}}"
                        },
                        {
                            headerText: "Time End", key: "TEND", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "85px",
                            template: "<div class ='ColumnContentExtend'>{{if(checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) === true}}<div class ='ColumnContentExtend'><input id='btnReqEnd' type='button' value='End' onclick='onclick_completeRequest(${REQID}, ${REQTYPEID}, ${MSID});' class='ColumnContentExtend'/></div>" +
                            "{{elseif (!checkNullOrUndefined(${TEND}) && !checkNullOrUndefined(${TSTART})) ===true}}<div class ='ColumnContentExtend'>${TEND}<span class='Mi4_undoIcon' onclick='undoRequestComplete(${MSID}, ${REQTYPEID})'></span></div>" +
                            "{{else}}<div class ='ColumnContentExtend'></div>{{/if}}"
                        },
                        {
                            headerText: "Tank Strapping", key: "STRAP", dataType: "string", width: "150px",
                            template: "<div><input id='btnReqStart' type='button' value='Edit Start' onclick=\"startStrapping(${MSID}, true);\" class='ColumnContentExtend'/></div>" +
                                    "<div><input id='btnReqStart' type='button' value='Edit End' onclick=\"endStrapping(${MSID}, false);\" class='ColumnContentExtend'/></div>"
                           
                        },

                        { headerText: "Loader Comments", key: "COMMENTS", dataType: "string", width: "200px" },

                    ],
                    features: [
                        {
                            name: 'Paging'
                        },
                        {
                            name: 'Resizing'
                        },
                        {
                            name: 'Updating',
                            enableAddRow: false,
                            editMode: "row",
                            enableDeleteRow: false,
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            cellClick: function (evt, ui) {

                            },

                            editCellStarting: function (evt, ui) {
                                if (!ui.rowAdding) {<%-- row edit --%>
                                    if (ui.columnKey === "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "STRAP") { <%-- disable timestamp column edits--%>
                                         return false;
                                     }
                                 }
                                 else { <%-- row edit --%>
                                    if (ui.columnKey === "TSTART" || ui.columnKey === "TEND" || ui.columnKey === "STRAP") { <%-- disable timestamp column edits--%>
                                         return false;
                                     }
                                 }
                             },
                             editRowStarting: function (evt, ui) {
                                 var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                 $("#editDialog").data("data-ReqID", ui.rowID);
                                 var isStartEndBtnClicked = $("#grid").data("data-STARTENDClick");
                                 if (isStartEndBtnClicked) { <%-- end editing if start/end btns were clicked, continue edit mode only when other cells are clicked --%>
                                     $("#grid").data("data-STARTENDClick", false); <%--reset--%>
                                 }
                                 //PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);
                                 return false;
                             },
                             editRowEnding: function (evt, ui) {
                                 if (!ui.rowAdding) {
                                     var origEvent = evt.originalEvent;
                                     if (typeof origEvent === "undefined") {
                                         ui.keepEditing = true;
                                         return false;
                                     }
                                     if (!(origEvent.type === "click" && ui.update === true)) { <%--  only update row when done button is clicked--%>

                                         if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                             ui.keepEditing = true;
                                            // PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);
                                         }
                                         return false;
                                     }
                                     else {
                                         var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                         PageMethods.updateRequest(row.REQID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                                     }
                                 }
                             },
                             columnSettings:
                             [
                                 { columnKey: "FUPLOAD", readOnly: true },
                                 { columnKey: "isOpenInCMS", readOnly: true },
                                 { columnKey: "REQID", readOnly: true },
                                 { columnKey: "MSID", readOnly: true },
                                 { columnKey: "SPOT", readOnly: true },
                                 { columnKey: "TRAILER", readOnly: true },
                                 { columnKey: "PRODCOUNT", readOnly: true },
                                 { columnKey: "PRODID", readOnly: true },
                                 { columnKey: "PRODDETAIL", readOnly: true },
                                 { columnKey: "PO", readOnly: true },
                                 { columnKey: "SPOTDESC", readOnly: true },
                                 { columnKey: "IMGUP", readOnly: true },
                                 { columnKey: "REQTYPENAME", readOnly: true },
                                 { columnKey: "TASK", readOnly: true },
                                 { columnKey: "LOADERNAME", readOnly: true },
                                 { columnKey: "REQUESTERNAME", readOnly: true },
                                 { columnKey: "TDUE", readOnly: true },
                                 { columnKey: "REJECT", readOnly: true },
                                 { columnKey: "TSTART" },
                                 { columnKey: "TEND" },
                                 {
                                     columnKey: "COMMENTS",
                                     editorType: "text",
                                     editorOptions: {
                                         maxLength: 250
                                     }
                                 },
                             ]
                        },
                        {
                            name: 'Sorting'
                        },
                        {
                        name: "Filtering",
                         allowFiltering: true,
                         caseSensitive: false,
                            columnSettings: [{ columnKey: "FUPLOAD", allowFiltering: false },
                                { columnKey: "MSID", allowFiltering: true },
                                { columnKey: "isOpenInCMS", allowFiltering: false },
                                { columnKey: "REQID", allowFiltering: false },
                                { columnKey: "SPOT", allowFiltering: false },
                                { columnKey: "PO", allowFiltering: false },
                                { columnKey: "TRAILER", allowFiltering: false },
                                { columnKey: "PRODCOUNT", allowFiltering: false },
                                { columnKey: "PRODID", allowFiltering: false },
                                { columnKey: "PRODDETAIL", allowFiltering: false },
                                { columnKey: "IMGUP", allowFiltering: false },
                                { columnKey: "REJECT", allowFiltering: false },
                                { columnKey: "SPOTDESC", allowFiltering: false },
                                { columnKey: "REQTYPENAME", allowFiltering: false },
                                { columnKey: "TASK", allowFiltering: false },
                                { columnKey: "LOADERNAME", allowFiltering: false },
                                { columnKey: "REQUESTERNAME", allowFiltering: false },
                                { columnKey: "TDUE", allowFiltering: false },
                                { columnKey: "TSTART" , allowFiltering: false },
                                { columnKey: "TEND" , allowFiltering: false },
                                { columnKey: "PATTERNS", allowFiltering: false },
                                { columnKey: "COMMENTS", allowFiltering: false }

                            ]
                        }
                    ]
                }); <%--end of $("#grid").igGrid({--%>


                $("#completedGrid").igGrid({
                    dataSource: GLOBAL_COMPLETE_DATA,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    renderCheckboxes: true,
                    primaryKey: "REQID",
                    columns:
                    [
                        {
                            headerText: "Rejected", key: "REJECT", dataType: "boolean", width: "65px", template: "{{if(${REJECT})}}" +
                            "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}"
                        },
                        {
                            headerText: "Is open in CMS", key: "isOpenInCMS", width: "0px", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${isOpenInCMS}</div>{{/if}}"
                        },
                        { headerText: "", key: "REQID", dataType: "number", width: "0px", hidden: true, readOnly: true },
                        {
                            headerText: "MSID", key: "MSID", dataType: "string", width: "0px", template: "{{if(${MSID} == -1)}}" +
                            "<div>(N/A)</div>{{else}}<div>${MSID}</div>{{/if}}"
                        },
                        { headerText: "PO", key: "PO", dataType: "string", width: "90px" },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "string", width: "150px" },
                        { headerText: "New Spot (If Applicable)", key: "NEWSPOT", dataType: "string", width: "100px" },
                        { headerText: "Requester (Task) Comments", key: "TASK", dataType: "string", width: "125px" },
                        { headerText: "Requester", key: "REQUESTER", dataType: "string", width: "75px" },
                        { headerText: "Time Assigned", key: "TIMEASSIGNED", dataType: "datetime", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Time Started", key: "TSTART", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Time End", key: "TEND", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "75px" },
                        { headerText: "Due Time ", key: "DUETIME", dataType: "date", format: "MM/dd/yyyy HH:mm:ss", width: "0px", hidden: true },
                        { headerText: "Assignee", key: "ASSIGNEE", dataType: "string", width: "125px" },
                        { headerText: "Assignee Comments", key: "COMMENTS", dataType: "string", width: "200px" },
                    ],
                    features: [
                        {
                            name: 'Paging'
                        },
                        {
                            name: 'Resizing'
                        },
                        {
                            name: 'Updating',
                            enableAddRow: false,
                            editMode: "row",
                            enableDeleteRow: false,
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            editRowStarting: function (evt, ui) {
                                var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                var isStartEndBtnClicked = $("#grid").data("data-STARTENDClick");
                                if (isStartEndBtnClicked) { <%-- end editing if start/end btns were clicked, continue edit mode only when other cells are clicked --%>
                                 $("#grid").data("data-STARTENDClick", false); <%--reset--%>
                             }
                             //PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);
                             return false;
                         },
                         editRowEnding: function (evt, ui) {
                             if (!ui.rowAdding) {
                                 var origEvent = evt.originalEvent;
                                 if (typeof origEvent === "undefined") {
                                     ui.keepEditing = true;
                                     return false;
                                 }
                                 if (!(origEvent.type === "click" && ui.update === true)) { <%--  only update row when done button is clicked--%>

                                     if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                         ui.keepEditing = true;
                                         //PageMethods.GetLogList(onSuccess_GetLogList, onFail_GetLogList);
                                     }
                                     return false;
                                 }
                                 else {
                                     var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                     PageMethods.updateRequest(row.REQID, ui.values.COMMENTS, onSuccess_updateRequest, onFail_updateRequest);
                                 }
                             }
                         },
                         columnSettings:
                         [
                             { columnKey: "isOpenInCMS", readOnly: true },
                             { columnKey: "PO", readOnly: true },
                             { columnKey: "MSID", readOnly: true },
                             { columnKey: "REQID", readOnly: true },
                             { columnKey: "TASK", readOnly: true },
                             { columnKey: "REQUESTER", readOnly: true },
                             { columnKey: "ASSIGNEE", readOnly: true },
                             { columnKey: "TIMEASSIGNED", readOnly: true },
                             { columnKey: "TSTART", readOnly: true },
                             { columnKey: "TEND", readOnly: true },
                             { columnKey: "COMMENTS", readOnly: true },
                             { columnKey: "NEWSPOT", readOnly: true },
                             { columnKey: "TRAILNUM", readOnly: true },
                             { columnKey: "NEWSPOT", readOnly: true },
                             { columnKey: "REJECT", readOnly: true },
                             { columnKey: "DUETIME", readOnly: true }
                         ]
                        }
                    ]

                }); <%--end complete grid--%>

                $("#gridPODetails").igGrid({
                    dataSource: null,
                    width: "100%",
                    virtualization: false,
                    autoGenerateColumns: false,
                    primaryKey: "PODETAILID",
                    columns:
                    [
                        { headerText: "", key: "PODETAILID", dataType: "number", width: "0%", hidden: true },
                        { headerText: "CMS Product ID ", key: "CMSPROD", dataType: "string", width: "150px", },
                        { headerText: "CMS Product Name", key: "CMSPRODNAME", dataType: "string", width: "150px", },
                        { headerText: "QTY", key: "QTY", dataType: "number", width: "150px", },
                        { headerText: "Unit", key: "UNIT", dataType: "string", width: "150px", }
                    ]
                });


            }
            var windowWidth = $(window).width();
            windowWidth = windowWidth - 10;
            $("#editDialog").igDialog({
                width: windowWidth + 'px',
                height: "500px",
                state: "closed",
                closeButtonTitle: "X"
            });



            $("#TankStrappingDialog").igDialog({
                width: windowWidth + 'px',
                height: "500px",
                state: "closed",
                closeButtonTitle: "X",
                //stateChanged: function (evt, ui) {
                //    if (ui.action === "close")
                //    {
                //        $("#editDialog").igDialog("open");
                //    }
                //}
            });




            PageMethods.getloaderTimeTrackingGridData(onSuccess_getLoaderTimeTrackingGridData, onFail_getLoaderTimeTrackingGridData);

             <%-- add grid cell click handler --%>
            $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {
                if (ui.colKey === 'TSTART' || ui.colKey === 'TEND') {
                    $("#grid").data("data-STARTENDClick", true);
                }
                else {
                    $("#grid").data("data-STARTENDClick", false);
                }
            });
            var igDiaHeight = ($(window).height() - ($(window).height() / 5))
            if (GLOBAL_IS_MOBILE_VIEWING == false) {
                igDiaWidth = "650";
                igDiaHeight = "650";
            }
            $("#dwProductDetails").igDialog({
                width: windowWidth + 'px',
                height: igDiaHeight + "px",
                state: "closed",
                modal: true,
                draggable: false
            });


            $("#dwFileUpload").igDialog({
                width: "600px",
                height: "550px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {
                        <%-- Delete attributes on controls --%>
                        $("#gridFiles").removeData("data-FPath");
                        $("#gridFiles").removeData("data-FNameNew");
                        $("#gridFiles").removeData("data-FNameOld");
                        $("#dwFileUpload").removeData("data-MSID");
                        $('#dBOLcontainer').removeData("data-fileID");
                        $('#dCOFAcontainer').removeData("data-fileID");
                        $("#dwFileUpload span.anr_t:contains('Add new file')").text("Add new row"); <%-- change back label on grid --%>
                        $('#dwFileUpload td[title="Click to start adding new file"]').attr('title', "Click to start adding new row");
                    }
                    //else if (ui.action === "open") {
                    //}
                }
            });
            $("#gridFiles").igGrid({
                dataSource: null,
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                primaryKey: "FID",
                columns:
                [
                    { headerText: "", key: "FID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "MSID", dataType: "number", width: "0%", hidden: true },
                    { headerText: "", key: "FPATH", dataType: "string", width: "0%", hidden: true },
                    { headerText: "", key: "FNAMENEW", dataType: "string", width: "0%", hidden: true },
                    { headerText: "File Name", key: "FNAMEOLD", dataType: "string", width: "30%", template: "<div><a href='${FPATH}\${FNAMENEW}'>${FNAMEOLD}</a></div>" },
                    { headerText: "Description", key: "DESC", dataType: "string", width: "60%" },
                    { headerText: "", key: "FUPDEL", dataType: "string", width: "10%", template: "<div><div><img src='Images/xclose.png' onclick='onclick_deleteFile(${FID});return false;' height='16' width='16'/></div></div>" },
                ],
                features:
                [
                    {
                        name: "Updating",
                        enableAddRow: true,
                        editMode: "row",
                        enableDeleteRow: false, <%-- // use clickable image since this only shows on row hover --%>
                            rowEditDialogContainment: "owner",
                            showReadonlyEditors: false,
                            enableDataDirtyException: false,
                            autoCommit: false,
                            rowAdding: function (evt, ui) {
                                if (ui.rowAdding) {
                                    var fpath = $("#gridFiles").data("data-FPath");
                                    var fnameNew = $("#gridFiles").data("data-FNameNew");
                                    var fnameOld = $("#gridFiles").data("data-FNameOld");
                                    if (fpath && fnameNew && fnameOld) {
                                        <%-- TODO: add code to insert new row with new file data --%>
                                        return true;
                                    }
                                    else {
                                        <%-- STOP Rowadded event --%>
                                        return false;
                                    }
                                }
                            },
                            rowAdded: function (evt, ui) {
                                var fpath = $("#gridFiles").data("data-FPath");
                                var fnameNew = $("#gridFiles").data("data-FNameNew");
                                var fnameOld = $("#gridFiles").data("data-FNameOld");
                                var msid = $("#dwFileUpload").data("data-MSID");
                                var desc = ui.values.DESC;

                                PageMethods.AddFileDBEntry(msid, "OTHER", fnameOld, fnameNew, fpath, desc, onSuccess_AddFileDBEntry, onFail_AddFileDBEntry);
                            },
                            editRowStarted: function (evt, ui) {
                                if (ui.rowAdding) {
                                    $("#igUploadOTHER_ibb_fp").click();
                                }
                                else { <%-- // do nothing; regular row is being edited --%>

                                }
                            },
                            editRowEnded: function (evt, ui) {
                                var origEvent = evt.originalEvent;
                                if (typeof origEvent === "undefined") {
                                    ui.keepEditing = true;
                                    return false;
                                }
                                <%-- change add new row's filename col back to blank column --%>
                                $("#gridFiles tr").eq(2).find('td:first-child').text("");

                                if (ui.update == true && ui.rowAdding == true && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                    if (!ui.update) {
                                        //do nothing 
                                    }
                                }
                                else if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                    //call update
                                    var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                    PageMethods.UpdateFileUploadData(row.FID, ui.values.DESC, onSuccess_UpdateFileUploadData, onFail_UpdateFileUploadData);
                                }
                            },
                            columnSettings: [

                                { columnKey: "FNAMEOLD", readOnly: true },
                                { columnKey: "FUPDEL", readOnly: true },
                                { columnKey: "DESC", editorType: "text" },

                            ]
                    },
                ]
            });

            $("#igUploadOTHER").igUpload({
                autostartupload: true,
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelecting: function (evt, ui) { },
                fileSelected: function (evt, ui) { showProgress(); },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#dwFileUpload").data("data-MSID");
                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "OTHER";
                    ctxVal[2] = MSID;
                    PageMethods.ProcessFileAndData(ui.filePath, "OTHER", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, ctxVal);
                    hideProgress();
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) { hideProgress(); sendtoErrorPage("Error in loaderTimeTracking.aspx, igUploadOTHER"); },

            });

            $("#igUploadIMAGE").igUpload({
                autostartupload: true,
                allowedExtensions: ["tiff", "gif", "bmp", "png", "jpg", "jpeg", "webp", "bpg", "pdf"],
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileSelected: function (evt, ui) {
                    showProgress();
                },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#igUploadIMAGE").data("MSID");

                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "IMAGE";
                    ctxVal[2] = MSID;
                    PageMethods.ProcessFileAndData(ui.filePath, "IMAGE", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, ctxVal);
                    hideProgress();
                    $("#igUploadIMAGE").data("MSID", null);
                },
                fileUploadedAborted: function (evt, ui) {
                    hideProgress();
                },
                onError: function (evt, ui) {
                    $("#igUploadIMAGE").data("MSID", null);
                    hideProgress();
                    if (ui.errorType.toString().contains("clientside") && ui.errorCode === 2) {
                        alert("Invalid file type. Please make sure you are uploading an image.");
                    }
                    else {
                        sendtoErrorPage("Error in loaderTimeTracking.aspx, igUploadImage");
                    }
                },
            });

           <%-- add grid cell click handler --%>
            $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {
                if (ui.colKey === 'PRODDETAIL' || ui.colKey === 'FUPLOAD') {
                    $("#grid").data("data-BUTTONClick", true);
                }
                else {
                    $("#grid").data("data-BUTTONClick", false);
                }
            });

            $('#iFtInGal').change(function () {
                 updateTotalGals();
            });
            $('#iFracGal').change(function () {
                  updateTotalGals();
            });


        });<%--end of $(function () {--%>
        
         $(".logWindow").hide();
</script>


    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow" style="display: none" >
        <div class="logTitleBar">
            <div id="logButton">
                <div id="tLogMax" style="display:none"><img src='Images/tLogMaxi.png' id="maxiIcon" /></div>
                <div id="tLogMini" ><img src='Images/tLogMini.png' id="miniIcon"/></div></div>
            Truck Log
        </div>
        <div id="logTableWrapper">
            <input id="cboxLogTruckList" />
            <div id="tableLog"></div>
        </div>
    </div>
    <h2>Open Loader Requests</h2>
    <table id="grid" class="scrollGridClass"></table>
    <br /><br />
    <h2>Completed Loader Requests</h2>
    <div class="dvHideShowButtons">
        <input type="button" id="btn_show_completeGrid" onclick="show_completeGrid(); return false;" value="Show" />
        <input type="button" id="btn_hide_completeGrid" onclick="hide_completeGrid(); return false;" value="Hide" />
    </div>
    <div id ="completeGridWrapper">
    <table id="completedGrid" class="scrollGridClass"></table></div>
    
    <div id ="editDialog">
        <table style="border: 0;">
            <tr><td><label class="mobileLbl">Rejectd Status: </label></td><td><label class="mobileLbl" id ="RejectEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">PO: </label></td><td><label class="mobileLbl" id ="POEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Trailer Number: </label></td><td><label class="mobileLbl" id ="TrailerEditDialog"></label></td></tr>
            <tr><td><label class="mobileLbl">Spot: </label></td><td><label class="mobileLbl" id ="spotEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Request Type: </label></td><td><label class="mobileLbl" id ="requestTypeEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Task Comments: </label></td><td><label class="mobileLbl" id ="taskCommentEditDialog"> </label></td></tr>
            <tr><td><label class="mobileLbl">Requested By: </label></td><td><label class="mobileLbl" id ="requestedByEditDialog"> </label></td></tr>
            <tr><td>    </td></tr>
  
        <tr><td><label class="mobileLbl">Time Started: </label></td><td><label class="mobileLbl" id ="timeStartedEditDialog"> </label>
                <input margin-top: 0; margin-bottom: 0;" id="btnTimeStartedEditDialog" type="button" value='Start Task' onclick="onclick_dialogButtonClick('moveFwd', 'start');"></td><td>
                 <span id="timeStartedUndoEditDialog" class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','start')"></span>
                <input margin-top: 0; margin-bottom: 0;" id="btnStrappingStartEditDialog" type="button" value='Edit Start Strap' onclick="onclick_dialogButtonClick('strap', 'start');"></td></tr>

        <tr><td><label class="mobileLbl">Time Ended: </label></td><td><label class="mobileLbl" id ="timeEndedEditDialog"> </label>
                <input id="btnTimeEndedEditDialog" type="button" value='Task Ended' onclick="onclick_dialogButtonClick('moveFwd', 'complete');"></td><td>
                <span style="float: left" id="timeEndedUndoEditDialog"  class="Mi4_undoIcon" onclick="onclick_dialogButtonClick('undo','complete')"></span>
                <input margin-top: 0; margin-bottom: 0;" id="btnStrappingEndEditDialog" type="button" value='Edit End Strap' onclick="onclick_dialogButtonClick('strap', 'complete');"></td></tr>
        <tr><td></td></tr>
        </table>

        <table style="border: 0;">
        <tr><td><label class="mobileLbl">Loader Comments:</label></td><td><textarea id="loaderCommentEditDialog" maxlength="250"></textarea></td></tr>
            <tr><td></td><td>
                <button type="button" id="btnViewPatterns" onclick=''>View Patterns</button>
                <button type="button" id="btnViewFiles" onclick=''>View Files</button>
                <button type="button" id="btnSave" onclick='onclick_btnSaveEditDialog(); return false;'>Save</button>
                <button type="button" id="btnCancel" onclick='onclick_btnCancelEditDialog(); return false;'>Cancel</button></td></tr>
        </table>
    </div>

    <div id="TankStrappingDialog">
        <h3 id="lblTankStrappingDialog">Tank Strapping</h3>
        <table >
            <tr><td>Tank#: </td><td><input id ="iTankNum" /></td></tr>
            <tr><td>Temp: </td><td> <input id ="iTemp"  type="number"/> </td></tr>
            <tr><td>Feet: </td><td> <input id ="iFt" type="number"/> </td></tr>
            <tr><td>Inches:</td><td> <input id ="iInches"  type="number"/> </td></tr>
            <tr><td>Ft & In converted to GALS:</td><td><input id ="iFtInGal" type="number" /> </td></tr>
            <tr><td>Fraction: </td><td> <input id ="iFracNum"  type="number"/> / <input id ="iFracDen" type="number"/></td></tr>
            <tr><td>Fraction converted to GALS:</td><td> <input id ="iFracGal"  type="number"/> </td></tr>
            <tr><td>Total GALS:</td><td><label id ="iTTLGal"></label> </td></tr>
            <tr><td>Flush </td><td> <input id ="iFlush" type="number"/> </td></tr>
        </table>
        <button type="button" id="btnSaveStrap" onclick='onclick_btnSaveStrap(); return false;'>Save</button>
        <button type="button" id="btnCancelStrap" onclick='onclick_btnCancelStrap(); return false;'>Cancel</button>
    </div>

     <div id="dwProductDetails">
        <h2><span>PO - Trailer:  <span id="dvProductDetailsPONUM"></span></span></h2>
        <table id="gridPODetails"></table>
    </div>
    
    <%-- dialog for file upload--%>
    <div id="dwFileUpload">
        <h2><span>Files for PO - Trailer:  <span id="POTrailer_dwFileUpload"></span></span></h2>
        <div class="ContentExtend"><table id="gridFiles" class="ContentExtend"></table></div>
        <br />
        <br />
        <button type="button" id="btnCloseFileDialog" onclick='onClick_CloseFileDialog();'>Close</button>
    </div>
    <div id="dvUploadsContainer" style='display: none;'>
        <div id="igUploadOTHER" style='display: none;' ></div>
        <input type="file" id = "igUploadIMAGE"  class = "CameraUpload" accept="image/*" capture='camera'>
    </div>
</asp:Content>
