<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="InspectionMobile.aspx.cs" Inherits="TransportationProject.InspectionMobile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="Content/InspectionsPageStyle.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    
    <style type="text/css">
        .resizeCameraImg
        {
            display: block;
            width: 100% !important;
            max-width: 48px !important;

        }
        .mi4-dialog-close-button
        {
            float: right;
            margin-right: 15px
        }

        .mi4-disabled-element
        {
            color: #999;
            opacity : .5;
        }

        .mi4-expandable-click
        {
            width:48px; /*width of your image*/
            height:48px; /*height of your image*/
            /*background-image:url('/Images/plus-sign.png');*/
            content: "/Images/plus-sign.png"
           
        }
        .mi4-expandable-click:hover
        {
            background-color: lightblue;
        }

        .mi4-element-hidden-before-selection
        {
            display: none;
        }

        .mi4-center-element
        {
            text-align:center; 
            vertical-align:middle;
        }
    </style>
    <script type="text/javascript">

        var InspectionObject = function () {
            return this.inspectionListData;
        };
        var selectedInspectionListData;

        $(function () {
            $(".arrowGridScrollButtons").show();
            PageMethods.getTruckAndProductList(onSuccess_getTruckAndProductList, onFail_getTruckAndProductList);



            $("#cboxTruckAndProdList").igCombo({
                dataSource: [],
                textKey: "TruckProdLabel",
                valueKey: "PODetailsID",
                width: "250px",
                virtualization: true,
				mode:1,
                placeHolder: "Select a Truck-Product",
                enableClearButton: true,
				autoSelectFirstMatch: false,
				
                selectionChanged: function (evt, ui) {
                    if (ui.items.length > 0) {
                        hideMessages();
                        showInitiallyHiddenObjects();
                        displayUpdateLocationDivElements();
                        var prodDetailsID = ui.items[0].data.PODetailsID;
                        PageMethods.getAvailableLocations(prodDetailsID, onSuccess_getAvailableLocations, onFail_getAvailableLocations, prodDetailsID);
                        PageMethods.getInspectionList(prodDetailsID, onSuccess_getInspectionList, onFail_getInspectionList);
                        PageMethods.getFileUploadsFromProdDetailID(prodDetailsID, onSuccess_getFileUploadsFromProdDetailID, onFail_getFileUploadsFromProdDetailID);
                        PageMethods.checkIfControlsCanBeUpdated(prodDetailsID, onSuccess_checkIfControlsCanBeUpdated, onFail_checkIfControlsCanBeUpdated);

                    }
                }
            });

            $('#cboxTruckAndProdList').attr('readonly', false);


            $("#cboxInspectionList").igCombo({
                dataSource: [],
                textKey: "InspectionListName",
                valueKey: "InspectionListID",
                width: "250px",
                virtualization: true,
                placeHolder: "Select an Inspection List",
                enableClearButton: false,
                selectionChanged: function (evt, ui) {

                    // var defaultInspectionListID = value[i][0];
                    if (ui.items.length > 0) {
                        var InspectionListID = ui.items[0].data.InspectionListID;
                        var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
                        if (selectedProdDetailID && InspectionListID) {
                            var contextParam = [];
                            contextParam["rebind"] = true;
                            PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)
                        }
                    }

                }
            });


            $('#cboxInspectionList').attr('readonly', true);

            $("#cboxLocationStatus").igCombo({
                dataSource: [{ "LOCSTATTEXT": null, "LOCSTAT": null }],
                textKey: "LOCSTATTEXT",
                valueKey: "LOCSTAT",
                width: "200px",
                autoComplete: true,
                mode: "dropdown",
                selectionChanged: function (evt, ui) {
                    if (ui.items[0].data.LOCSTAT == "DOCKBULK" || ui.items[0].data.LOCSTAT == "DOCKVAN") {
                        $("#dvLocDockSpot").show();
                    }
                    else {
                        $("#dvLocDockSpot").hide();
                    }
                }
            });
            $('#cboxLocationStatus').attr('readonly', true);

            $("#cboxDockSpots").igCombo({
                dataSource: null,
                textKey: "DOCKSPOT",
                valueKey: "SPOTID",
                width: "200px",
                autoComplete: true,
                enableClearButton: false
            });

            $('#cboxDockSpots').attr('readonly', true);


            $("#gridOfInspectionsUnderList").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                //renderCheckboxes: true,
                primaryKey: "MSInspectionListDetailID",
                columns:
                    [
                        { headerText: "", key: "MSInspectionListID", dataType: "number", width: "0%" },
                        { headerText: "", key: "MSInspectionID", dataType: "number", width: "0%" },
                        { headerText: "", key: "InspectionHeaderID", dataType: "number", width: "0%" },
                        { headerText: "", key: "MSInspectionListDetailID", dataType: "number", width: "0%" },
                        { headerText: "", key: "InspectionStartEventID", dataType: "number", width: "0%" },
                        { headerText: "", key: "InspectionEndEventID", dataType: "number", width: "0%" },
                        { headerText: "", key: "InspectionTypeID", dataType: "number", width: "0%" },
                        { headerText: "", key: "LoadType", dataType: "string", width: "0%" },
                        { headerText: "", key: "UserID", dataType: "number", width: "0%" },
                        { headerText: "", key: "RunNumber", dataType: "number", width: "0%" },
                        { headerText: "", key: "InspectionComment", dataType: "string", width: "0%" },
                        { headerText: "", key: "wasAutoClosed", dataType: "bool", width: "0%" },
                         {
                             headerText: "Image Upload", key: "CAMERA", dataType: "text", width: "10%", template:
                             "<img id = 'CameraImg' src ='Images/camera48x48.png' class='resizeCameraImg mi4-editInspection'  onclick='OnClick_AddImage(${MSInspectionListDetailID}); return false;'/>"
                         },
                        { headerText: "Sort Order", key: "SortOrder", dataType: "number", width: "10%" },
                        { headerText: "Inspection Name", key: "InspectionHeaderName", dataType: "text", width: "50%" },
                        {
                            headerText: "Verification Test", key: "needsVerificationTest", dataType: "number", width: "10%",
                            template: "{{if ${needsVerificationTest} === 1}}<div  class='mi4-center-element'><input type='checkbox' checked='checked' disabled='disabled' /></div>{{else}}<div  class='mi4-center-element'><input type='checkbox' disabled='disabled' /></div>{{/if}}"
                        },
                        {
                            headerText: "Complete", key: "Complete", dataType: "number", width: "10%",
                            template: "{{if ${Complete}  === 0}}<div  class='redCell mi4-center-element''><input type='checkbox' disabled='disabled'></div>{{else}}<div  class='mi4-center-element'><input type='checkbox' checked='checked' disabled='disabled'></div>{{/if}}"
                        },
                        {
                            headerText: "Failed", key: "isFailed", dataType: "number", width: "10%",
                            template: "{{if ${isFailed}  === 1}}<div  class='redCell mi4-center-element''><input type='checkbox' checked='checked' disabled='disabled' /></div>{{else}}<div  class='mi4-center-element'><input type='checkbox' disabled='disabled' /></div>{{/if}}"
                        },
                        {
                            headerText: "Additional Details", key: "Details", dataType: "text", width: "10%",
                            template: "<div class ='ColumnContentExtend'>" +
                                            "<input id='btnDetails'+ type='button' value='View Details' onclick='GetInspectionDetailsData(${MSInspectionListDetailID}, \"${MSInspectionID}\", \"${InspectionComment}\")' class='ColumnContentExtend'/>" +
                                        "</div>"
                        },

                    ],
                features: [{
                    name: "Selection",
                    mode: "row",
                    multipleSelection: false,
                    activation: true,
                    rowSelectionChanged: function (evt, ui) {

                    },

                }],
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
                { headerText: "Filename", key: "FNAMEOLD", dataType: "string", width: "35%", template: "<div><a href='${FPATH}\${FNAMENEW}'>${FNAMEOLD}</a></div>" },
                { headerText: "Description", key: "DESC", dataType: "string", width: "65%" },
                ],
            });



            $("#dwInspectionQuestions").igDialog({
                width: "95%",
                height: "500px",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "open") {
                        $("#tblQuestions").data("questNum", 1);
                    }
                    if (ui.action === "close") {
                        var oInspectionList = selectedInspectionListData();
                        var oInspectionListDetails = [];
                        oInspectionListDetails = oInspectionList.InspectionListDetails; //List of available  Inspections
                        var rowData = $("#gridOfInspectionsUnderList").igGridSelection("selectedRow");
                        var indexOfRowToSelect = rowData.index;
                        populateInspectionGridData(oInspectionListDetails);
                        $('#gridOfInspectionsUnderList').igGridSelection('selectRow', indexOfRowToSelect);
                    }



                }
            });

            $("#dwInspectionDetails").igDialog({
                width: "95%",
                height: "100%",
                state: "closed",
                modal: true,
                draggable: false,
                stateChanging: function (evt, ui) {
                    if (ui.action === "close") {

                    }
                }
            });


            $(".up_nav").on("click", function () {
                var questionNum = $("#tblQuestions").data("questNum");
                if (questionNum > 1) {

                    $("#trQuestion" + questionNum).hide();
                    $("#trQuestion" + (questionNum - 1)).show();
                    $("#tblQuestions").data("questNum", questionNum - 1);
                }
                return false;
            });

            $(".down_nav").on("click", function () {
                var rowCount = $('#tblQuestions tr').length;
                var questionNum = $("#tblQuestions").data("questNum");
                var isChecked = $("input:radio[name='rd_Questions" + questionNum + "']").is(":checked")
                if (!isChecked) {
                    alert("Please select an answer before continuing to the next question.");
                    return false;
                }
                if (questionNum < rowCount) {
                    $("#trQuestion" + questionNum).hide();
                    $("#trQuestion" + (questionNum + 1)).show();
                    $("#tblQuestions").data("questNum", questionNum + 1);
                }
                return false;
            });

            $("#gridMissingResults").igGrid({
                dataSource: [],
                width: "100%",
                virtualization: false,
                autoGenerateColumns: false,
                autofitLastColumn: true,
                renderCheckboxes: true,
                primaryKey: "MSID",
                columns:
                    [

                        { headerText: "", key: "MSID", dataType: "number", width: "0px", hidden: true },
                        { headerText: "", key: "LOCSTAT", dataType: "text", width: "0px", hidden: true },
                        { headerText: "", key: "REJECTED", dataType: "text", width: "0px", hidden: true },
                        {
                            headerText: "Rejected", key: "REJECTEDTEXT", dataType: "text", width: "65px", template: "{{if(${REJECTED})}}" +
                                        "<div class ='needsTruckMove'>${REJECTEDTEXT}</div>{{else}}<div>${REJECTEDTEXT}</div>{{/if}}"
                        },
                        { headerText: "PO", key: "PONUM", dataType: "number", width: "90px", },
                        { headerText: "Trailer#", key: "TRAILNUM", dataType: "text", width: "150px", },
                         {
                             headerText: "Product", key: "PRODID", dataType: "string", width: "150px"
                         },
                         {
                             headerText: "Product Detail", key: "PRODDETAIL", dataType: "string", width: "150px"
                         },
                        { headerText: "ETA", key: "ETA", dataType: "date", width: "125px", format: "MM/dd/yyyy HH:mm", },
                        { headerText: "Location", key: "LOCLONG", dataType: "text", width: "125px" },
                        {
                            headerText: "Inspection Finished", key: "INSPCLOSED", dataType: "bool", width: "125px",
                        },
                        { headerText: "Inspection Failed", key: "ISFAILEDVALUE", dataType: "bool", width: "175px", },

                        { headerText: "Inspection Name", key: "INSP", dataType: "text", width: "175px", },
                    ],
                features: [
                           {
                               name: "Filtering",
                               dataFiltering: function (evt, ui) {

                                   var nExpressions = [];
                                   for (i = 0; i < ui.newExpressions.length; i++) {
                                       var newcond = ui.newExpressions[i].cond;
                                       var newExpr = ui.newExpressions[i].expr;
                                       var newFieldName = ui.newExpressions[i].fieldName;
                                       if (!checkNullOrUndefined(newExpr)) {
                                           if (newFieldName.contains("ETA")) {
                                               ui.newExpressions[i].preciseDateFormat = null;
                                           }

                                           nExpressions.push(ui.newExpressions[i]);
                                       }

                                   }
                                   $("#gridMissingResults").igGridFiltering("filter", nExpressions);
                                   return false;
                               },
                           }
                ]

            }); <%--end of $("#gridMissing")--%>


            $(document).delegate("#gridOfInspectionsUnderList", "iggridcellclick", function (evt, ui) {
                if (ui.colKey === 'Details' || ui.colKey === 'CAMERA') {
                    <%--do nothing ; button onclick handlers for these column will fire instead--%>
                }
                else {

                    var rowData = $("#gridOfInspectionsUnderList").igGridSelection("selectedRow");
                    var rowID = rowData.id;
                    //checkIfInspectionCanBeEdited(MSInspectionListDetailID, MSInspectionID, Comments)

                    var ds = $("#gridOfInspectionsUnderList").igGrid("option", "dataSource");
                    var inspectionRowData = ds[rowData.index];

                    var isDisabled = $("#gridOfInspectionsUnderList").data("isDisabled");
                    var response = true;
                    if (isDisabled) {
                        response = confirm("Inspections are currently locked. Please check the status and location of the truck to see if there are pending actions preventing the inspections from being performed or if it is at a location where an inspection can be done. Continue inspection anyways?");
                    }
                    if (response && !checkNullOrUndefined(inspectionRowData)) {
                        checkIfInspectionCanBeEdited(inspectionRowData.MSInspectionListDetailID, inspectionRowData.MSInspectionListID, inspectionRowData.MSInspectionID, inspectionRowData.Comments);
                        
                    }

                }
            });



            $("#igUploadIMAGE").igUpload({
                autostartupload: true,
                allowedExtensions: ["tiff", "gif", "bmp", "png", "jpg", "jpeg", "webp", "bpg", "pdf"],
                progressUrl: "~/IGUploadStatusHandler.ashx",
                fileExtensionsValidating: function (evt, ui) {
                    var check = ui;
                },
                fileSelected: function (evt, ui) {
                    showProgress();
                },
                fileUploaded: function (evt, ui) {
                    <%-- call pagemethod to process file and data--%>
                    var ctxVal = [];
                    var MSID = $("#igUploadIMAGE").data("MSID");

                    ctxVal[0] = ui.filePath;
                    ctxVal[1] = "IMAGE";
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
                        sendtoErrorPage("Error in inspectionMobile.aspx, igUploadImage");
                    }
                },
            });



            <%-- Call any pageloads for setting up data for controls--%>
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);

        }); <%--//END OF PAGELOAD--%>

        

        <%-----------------------------------------------------------------------------------------------
        //FUNCTIONS
        //----------------------------------------------------------------------------------------------%>

        Number.prototype.padLeft = function (base, chr) {
            var len = (String(base || 10).length - String(this).length) + 1;
            return len > 0 ? new Array(len).join(chr || '0') + this : this;
        }


        function displayUpdateLocationDivElements() {

            $("#dvUpdateTruckLocation").hide();
            $("#dvUpdateTruckLocation-Plus").show();
            $("#dvUpdateTruckLocation-Minus").hide();
        }


        function OnClick_AddImage(evt, msid, id) {

            var isDisabled = $("#gridOfInspectionsUnderList").data("isDisabled");
            if (!isDisabled) {
                $('#igUploadIMAGE').data("MSID", msid);
                $("#igUploadIMAGE_ibb_fp").click();
            }
            else {
                alert("Inspections are currently locked. Please check the status and location of the truck to see if there are pending actions preventing the inspections from being performed or if it is at a location where an inspection can be done.");
            }
        }


        function toggleDisplayItem(itemName) {
            // var isVisible = $('#' + itemName + ':visible');
            var isVisible = $('#' + itemName).is(":visible");
            if (isVisible) {
                $("#" + itemName).hide();
            }
            else {
                $("#" + itemName).show();
            }
        }
        $(window).resize(function () {

            $("#dwInspectionDetails").dialog("option", "position", "center");
            $("#dwInspectionQuestions").dialog("option", "position", "center");

        });

        function scrolltoItem(ElementID) {
            var offset = $(this).offset(); // Contains .top and .left
            offset.left -= 20;
            offset.top -= 20;
            $('html, body').animate({
                scrollTop: offset.top,
                scrollLeft: offset.left
            });
        }

        <%-----------------------------------------------------------------------------------------------
        //ONCLICK HANDLERS
        //----------------------------------------------------------------------------------------------%>

        function saveComment() {
            $("#lblSaving").show();
            var msInspectionID = $("#dwInspectionDetails").data("MSInspectionID");
            var newComment = $("#txtInspDetailComments").text();
            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            PageMethods.updateInspectionComment(selectedProdDetailID, msInspectionID, newComment, onSuccess_updateInspectionComment, onFail_updateInspectionComment)

        }

        function closeIGDialog(DialogName) {
            $("#" + DialogName).igDialog("close");
        }

        function onclick_UpdateLocation() {
            var locstatItems = $("#cboxLocationStatus").igCombo("selectedItems");
            var dockSpot = $("#cboxDockSpots").igCombo("selectedItems");
            var canUpdate = false;

            if (locstatItems) {
                if (locstatItems[0].data.LOCSTAT == 'DOCKVAN' || locstatItems[0].data.LOCSTAT == 'DOCKBULK') {
                    if (checkNullOrUndefined(dockSpot)) {
                        alert("You must specify which dock spot you want to move to. ");
                    }
                    else {
                        canUpdate = true;
                    }
                }
                else {
                    canUpdate = true;
                }
            }

            if (canUpdate == true) {
                var locstat = locstatItems[0].data.LOCSTAT;
                var dockSpotID = null;
                if (!checkNullOrUndefined(dockSpot)) {
                    dockSpotID = dockSpot[0].data.SPOTID;
                }

                var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
                PageMethods.updateLocation(selectedProdDetailID, locstat, dockSpotID, onSuccess_updateLocation, onFail_updateLocation);
            }
        }

        function clearTruckScheduleGridFilter(evt, ui) {
            $("#gridMissingResults").igGridFiltering("filter", []);
        }
        function todayFilterForGridMissingResults() {
            var today = new Date();

            $("#gridMissingResults").igGridFiltering("filter",
                [{ fieldName: "ETA", expr: today, cond: "today" }],
                true);
        }
        function onclick_ShowAllTrucks(evt, ui) {
            clearTruckScheduleGridFilter()
        }
        function onclick_ShowTodayOnly(evt, ui) {

            clearTruckScheduleGridFilter();
            todayFilterForGridMissingResults();
        }

        function checkIfInspectionCanBeEdited(MSInspectionListDetailID, MSInspectionListID, MSInspectionID, Comments) {
            $("#dwInspectionDetails").data("MSInspectionID", MSInspectionID);
            var contextParam = [];
            contextParam["MSInspectionListDetailID"] = MSInspectionListDetailID;
            contextParam["MSInspectionID"] = MSInspectionID;
            contextParam["Comments"] = Comments;

            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            PageMethods.canInspectionBeEdited(selectedProdDetailID, MSInspectionListID, MSInspectionID, onSuccess_canInspectionBeEdited, onFail_canInspectionBeEdited, contextParam);
        }


        function getInspectionObject(MSInspectionListDetailID) {
            var InspectionListData = selectedInspectionListData();
            var MSInspection = null;
            for (i = 0; i < InspectionListData.InspectionListDetails.length; i++) {
                //   MSInspection = returnItemFromArray(InspectionListData.InspectionListDetails[i], "MSInspectionListDetailID", MSInspectionListDetailID, "MSInspection");
                if (InspectionListData.InspectionListDetails[i].MSInspectionListDetailsID === MSInspectionListDetailID) {
                    MSInspection = InspectionListData.InspectionListDetails[i].MSInspection
                }
                if (MSInspection) {
                    break;
                }
            }
            return MSInspection;
        }
        function GetInspectionDetailsData(MSInspectionListDetailID, MSInspectionID, Comments) {


            var MSInspection = getInspectionObject(MSInspectionListDetailID)

            if (MSInspection) {
                var MSStartEvent = MSInspection.MSStartEvent;
                var MSEndEvent = MSInspection.MSEndEvent;
                var UserInfoLastModified = MSInspection.UserLastModified._FirstName + " " + MSInspection.UserLastModified._LastName;
                var UserInfoVerifying = MSInspection.UserVerifying._FirstName + " " + MSInspection.UserVerifying._LastName;
                var UserInfoCreated = MSInspection.UserCreated._FirstName + " " + MSInspection.UserCreated._LastName;
                var timeLastModified = checkNullOrUndefined(UserInfoLastModified) ? "" : MSInspection.LastModifiedTimestamp;

                if (MSInspection.needsVerificationTest) {
                    $("#trVerifiedDetail").show();
                    $("#spInspDetailVerifiedBy").text(UserInfoVerifying);
                }
                else {

                    $("#trVerifiedDetail").hide();
                }
                $("#spInspDetailCreatedBy").text(UserInfoCreated);
                $("#spInspDetailLastEditedBy").text(UserInfoLastModified);
                $("#spInspDetailTimeLastEditedBy").text(timeLastModified);
                $("#spInspDetailTimeStart").text(MSStartEvent.EventTypeID === 0 ? "" : MSStartEvent.TimeStamp);
                $("#spInspDetailTimeEnd").text(MSEndEvent.EventTypeID === 0 ? "" : MSEndEvent.TimeStamp);
                $("#txtInspDetailComments").text(Comments);

                $("#dwInspectionDetails").igDialog("open");
            }
        }

        function setTestResult(testID, MSInspectionID, inspectionQuestionObjIndex, result, clickedItem) {
            <%--//update ui--%>
            $("input:radio[name=" + clickedItem[0].name + "]").prop("checked", false);
            $("input:radio[name=" + clickedItem[0].name + "]").removeAttr("checked");
            clickedItem.prop("checked", true);
            clickedItem.attr("checked", true);

            showProgress();
            var rowData = $("#gridOfInspectionsUnderList").igGridSelection("selectedRow");
            var MSInspectionListDetailID = rowData.id;
            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            var questionNumber = clickedItem[0].id.substr(0, clickedItem[0].id.indexOf('_'));

            switch (result) {
                case 0:
                    $("#" + questionNumber + "_1").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_-1").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_0").parent().css("background-color", "#33cc33");
                    break;
                case 1:
                    $("#" + questionNumber + "_0").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_-1").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_1").parent().css("background-color", "#33cc33");
                    break;
                case -1:
                    $("#" + questionNumber + "_0").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_1").parent().css("background-color", "#ffffff");
                    $("#" + questionNumber + "_-1").parent().css("background-color", "#33cc33");
                    break;
            }
            PageMethods.setInspectionResult(MSInspectionID, testID, result, selectedProdDetailID, onSuccess_setInspectionResult, onFail_setInspectionResult);
        }

        function createQuestionsTable(inspectionQuestions) {
            var newHtmlToAppend = "<table id=\"tblQuestions\" style=\"width:100%; height:80%\" data-questNum=\"1\">";

            for (i = 0; i < inspectionQuestions.length; i++) {
                var questionNum = i + 1;
                var tdContentHTML = "<div align=\"left\">" + inspectionQuestions[i].TestDescription + "</div><div align=\"left\" id=\"dv_rad" + questionNum + "\">\</div>";

                newHtmlToAppend = newHtmlToAppend + "<tr id=\"trQuestion" + questionNum + "\" style=\"width:100%; height:100%; display: none;\" data-TestID=\"" + inspectionQuestions[i].TestID + "\" data-isDealBreaker=\"" + inspectionQuestions[i].isDealBreaker +
                                        "\"data-Result=\"" + inspectionQuestions[i].Result + "\" ><td class=\"inspectionquestions\"><div align=\"center\">" + tdContentHTML + "</div></td></tr>"

            }

            newHtmlToAppend = newHtmlToAppend + "</table>";

            $("#dvQuestionsArea").append(newHtmlToAppend);

        }

        function createQuestionDivContent(inspectionQuestions, MSInspectionID) {
            for (i = 0; i < inspectionQuestions.length; i++) {
                var questionNum = i + 1;

                var testID = inspectionQuestions[i].TestID;
                var checkedNA = "";
                var checkedPASS = "";
                var checkedFAIL = "";

                var styleNA = "";
                var stylePASS = "";
                var styleFAIL = "";

                var styleNA2 = "";
                var stylePASS2 = "";
                var styleFAIL2 = "";
                switch (inspectionQuestions[i].Result) {
                    case -1: checkedNA = "checked=\"checked\""; styleNA = "style=\"background-color:#33cc33\""; styleNA2 = "style=\"font-weight: bolder\""; break;
                    case 0: checkedFAIL = "checked=\"checked\""; styleFAIL = "style=\"background-color:#33cc33\""; styleFAIL2 = "style=\"font-weight: bolder\""; break;
                    case 1: checkedPASS = "checked=\"checked\""; stylePASS = "style=\"background-color:#33cc33\""; stylePASS2 = "style=\"font-weight: bolder\""; break;
                    default: break;
                }


                var radioButtonPASS = "</br><div " + stylePASS + "><input id=\"" + i + "_" + 1 + "\"" + stylePASS2 + " class=\"mi4-editInspection rad_question\"" + checkedPASS + "  onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + 1 + ",$(this));\" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"1\" data-TestID=\"" + testID + "\"> PASS</div>";

                var radioButtonFAIL = "</br><div " + styleFAIL + "><input id=\"" + i + "_" + 0 + "\"" + styleFAIL2 + " class=\"mi4-editInspection rad_question\"" + checkedFAIL + "  onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + 0 + ",$(this)); \" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"0\" data-TestID=\"" + testID + "\"> FAIL</div>";

                var radioButtonNA = "</br><div " + styleNA + "><input id=\"" + i + "_" + -1 + "\"" + styleNA2 + " class=\"mi4-editInspection rad_question\"" + checkedNA + " onclick=\"setTestResult(" + testID + "," + MSInspectionID + "," + i + "," + -1 + ",$(this)); \" type=\"radio\" name=\"rd_Questions" + questionNum + "\" value=\"-1\" data-TestID=\"" + testID + "\"> N/A</div>";

                var dvName = "#dv_rad" + questionNum;
                $(dvName).append(radioButtonPASS).append(radioButtonFAIL).append(radioButtonNA);

            }
        }

        function createQuestionsAreaHTML(inspectionQuestions, MSInspectionID) {
            $("#dvQuestionsArea").empty();
            if (inspectionQuestions.length > 0) {
                createQuestionsTable(inspectionQuestions);
                createQuestionDivContent(inspectionQuestions, MSInspectionID);
            }
        }



        function populateQuestions(MSInspectionListDetailID) {
            var InspectionListData = selectedInspectionListData();
            var inspectionQuestions = null;
            var MSInspectionID = null
            for (i = 0; i < InspectionListData.InspectionListDetails.length; i++) {
                //   MSInspection = returnItemFromArray(InspectionListData.InspectionListDetails[i], "MSInspectionListDetailID", MSInspectionListDetailID, "MSInspection");

                if (InspectionListData.InspectionListDetails[i].MSInspectionListDetailsID === MSInspectionListDetailID) {
                    inspectionQuestions = InspectionListData.InspectionListDetails[i].MSInspection.questions
                }
                if (inspectionQuestions) {
                    MSInspectionID = InspectionListData.InspectionListDetails[i].MSInspection.MSInspectionID
                    break;
                }
            }
            if (inspectionQuestions) {
                createQuestionsAreaHTML(inspectionQuestions, MSInspectionID);
                $("#trQuestion1").show();
            }

        }

        function showInitiallyHiddenObjects() {

            $(".mi4-element-hidden-before-selection").show();
        }
        function hideInitiallyHiddenObjects() {

            $(".mi4-element-hidden-before-selection").hide();
        }

        function hideMessages() {
            $("#msgUpdateTruck").hide();
            $("#msgEditInspection").hide();
        }
        function enableUpdateLocation() {
            $("#msgUpdateTruck").hide();
            $(".mi4-updateLocation").attr("disabled", false);
            $(".mi4-updateLocation").prop("disabled", false);
            $(".mi4-updateLocation").attr("readonly", false);
            $(".mi4-updateLocation").removeClass("mi4-disabled-element");
            showInitiallyHiddenObjects();
        }

        function disableUpdateLocation() {
            $("#msgUpdateTruck").show();
            $(".mi4-updateLocation").attr("disabled", true);
            $(".mi4-updateLocation").attr("readonly", true);
            $(".mi4-updateLocation").prop("readonly", true);
            $(".mi4-updateLocation").addClass("mi4-disabled-element");
            hideInitiallyHiddenObjects();
        }

        function enableEditInspection() {
            $("#msgEditInspection").hide();
            $(".mi4-editInspection").attr("disabled", false);
            $(".mi4-editInspection").attr("readonly", false);
            $(".mi4-editInspection").prop("readonly", false);
            $("#gridOfInspectionsUnderList").data("isDisabled", false);
            //  $(".mi4-editInspection").removeAttr("disabled", "disabled");
            $(".mi4-editInspection").removeAttr("disabled");
            $(".mi4-editInspection").removeClass("mi4-disabled-element");

        }
        function disableEditInspection() {
            $("#msgEditInspection").show();
            $(".mi4-editInspection").attr("disabled", true);
            $(".mi4-editInspection").attr("readonly", true);
            $(".mi4-editInspection").prop("readonly", true);
            $("#gridOfInspectionsUnderList").data("isDisabled", true);
            //$(".mi4-editInspection").attr("disabled", "disabled");
            $(".mi4-editInspection").addClass("mi4-disabled-element");
        }
        <%-----------------------------------------------------------------------------------------------
        //PAGEMETHOD ONSUCCESS AND ONFAIL HANDLERS
        //----------------------------------------------------------------------------------------------%>



        function onSuccess_checkIfControlsCanBeUpdated(value, ctx, methodName) {
            if (value) {
                var canUpdateLocation = value[0];
                var canEditInspection = value[1];

                if (!canUpdateLocation) {
                    disableUpdateLocation()
                }
                else {
                    enableUpdateLocation()
                }
                if (!canEditInspection) {
                    disableEditInspection()
                }
                else {
                    enableEditInspection()
                }
            }


        }
        function onFail_checkIfControlsCanBeUpdated(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_checkIfControlsCanBeUpdated");
        }

        function onSuccess_canInspectionBeEdited(value, ctx, methodName) {
            if (!checkNullOrUndefined(value)) {
                var canEdit = value[0];
                var msg = value[1];

                if (canEdit) {
                    var isDisabled = $("#gridOfInspectionsUnderList").data("isDisabled");
                    var MSInspectionListDetailID = ctx["MSInspectionListDetailID"];
                    var MSInspectionID = ctx["MSInspectionID"];
                    var Comments = ctx["Comments"];

                    //if inspection has not been started
                    var MSInspection = getInspectionObject(MSInspectionListDetailID)
                    if (MSInspection && !isDisabled) {
                        var MSStartEvent = MSInspection.MSStartEvent;
                        if (MSStartEvent.EventTypeID === 0) {
                            //start inspection 
                            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
                            PageMethods.startInspection(selectedProdDetailID, MSInspectionID, onSuccess_startInspection, onFail_startInspection, ctx);
                        }
                    }

                    populateQuestions(MSInspectionListDetailID);


                    if (isDisabled) {
                        disableEditInspection()
                    }
                    $("#dwInspectionQuestions").igDialog("open");



                }
                else {
                    if (!checkNullOrUndefined(msg)) {
                        alert(msg);
                    }
                }
            }
        }

        function onFail_canInspectionBeEdited(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_canInspectionBeEdited");
        }

        function onSuccess_startInspection(value, ctx, methodName) {
            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            var InspectionListID = $("#cboxInspectionList").igCombo("value");
            if (selectedProdDetailID && InspectionListID) {
                var contextParam = [];
                contextParam["rebind"] = true;
                contextParam["closeInspectionDialog"] = false;
                PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)
            }
            PageMethods.getListofTrucksCurrentlyInZXPWithIncompleteTest(onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest);
        }
        function onFail_startInspection(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_startInspection");

        }

        function onSuccess_updateInspectionComment(value, ctx, methodName) {
            <%-- add code as needed --%>

            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            var InspectionListID = $("#cboxInspectionList").igCombo("value");
            if (selectedProdDetailID && InspectionListID) {
                var contextParam = [];
                contextParam["rebind"] = true;
                contextParam["closeInspectionDialog"] = false;
                PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)
            }

            $("#lblSaving").fadeOut(2000);
        }

        function onFail_updateInspectionComment(value, ctx, methodName) {
            hideProgress();
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_updateInspectionComment");
        }


        function onSuccess_getFileUploadsFromProdDetailID(value, MSID, methodName) {
            var gridData = [];
            if (value.length > 0) {
                var gridData = [];

                var rowCount = 0;
                for (var i = 0; i < value.length; i++) {
                    gridData[i] = { "FID": value[i][0], "MSID": value[i][1], "DESC": value[i][3], "FPATH": value[i][4], "FNAMENEW": value[i][5], "FNAMEOLD": value[i][6], "FUPDEL": "" };
                }
            }
            $("#gridFiles").igGrid("option", "dataSource", gridData);
            $("#gridFiles").igGrid("dataBind");
        }

        function onFail_getFileUploadsFromProdDetailID(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getFileUploadsFromProdDetailID");
        }




        function onSuccess_ProcessFileAndData(value, FileInfo, methodName) {
            if (FileInfo) {
                var fileuploadType = FileInfo[1];
                if ("IMAGE" === fileuploadType) {
                    //Add entry into DB 
                    var timestamp = new Date().toLocaleDateString();
                    var imageDescription = "Inspections Uploaded Image " + timestamp;
                    var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");

                    PageMethods.AddFileDBEntry(selectedProdDetailID, "IMAGE", FileInfo[0], value[1], value[0], imageDescription, onSuccess_AddFileDBEntry, onFail_AddFileDBEntry)
                }

            }
        }

        function onFail_ProcessFileAndData(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_ProcessFileAndData");
        }
        function onSuccess_AddFileDBEntry(value, ctx, methodName) {

            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
            if (!checkNullOrUndefined(selectedProdDetailID)) {
                PageMethods.getFileUploadsFromProdDetailID(selectedProdDetailID, onSuccess_getFileUploadsFromProdDetailID, onFail_getFileUploadsFromProdDetailID);
            }
        }

        function onFail_AddFileDBEntry(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_AddFileDBEntry");


        }

        function onSuccess_getAvailableDockSpots(value, prodDetailsID, methodName) {
            var dockSpot = [];
            for (i = 0; i < value.length; i++) {
                dockSpot[i] = { "SPOTID": value[i][0], "DOCKSPOT": value[i][1] };
            }
            $("#cboxDockSpots").igCombo("option", "dataSource", dockSpot);
            $("#cboxDockSpots").igCombo("dataBind");
            PageMethods.getDefaultDockSpot(prodDetailsID, onSuccess_getDefaultDockSpot, onFail_getDefaultDockSpot, prodDetailsID);
        }

        function onFail_getAvailableDockSpots(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx onFail_getAvailableDockSpots");
        }

        function onSuccess_getDefaultDockSpot(currentOrAssignedSpot, prodDetailsID, methodName) {
            $("#cboxDockSpots").igCombo("value", null);

            <%-- 0 = no spot, 3015 = Yard, & 3017 = Wait Area --%>
            if (currentOrAssignedSpot != 0 && currentOrAssignedSpot != 3015 && currentOrAssignedSpot != 3017) {
                $("#cboxDockSpots").igCombo("value", currentOrAssignedSpot);
            }
            PageMethods.getTruckAndDataAvailableForInspections(prodDetailsID, onSuccess_getTruckAndDataAvailableForInspections, onFail_getTruckAndDataAvailableForInspections);

        }

        function onFail_getDefaultDockSpot(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx onFail_getDefaultDockSpot");
        }

        function onSuccess_getAvailableLocations(value, prodDetailsID, methodName) {
            var cboxData = [];
            cboxData.length = 0;
            for (i = 0; i < value.length; i++) {
                cboxData[i] = { "LOCSTAT": value[i][0], "LOCSTATTEXT": value[i][1] };
            }
            $("#cboxLocationStatus").igCombo("option", "dataSource", cboxData);
            $("#cboxLocationStatus").igCombo("dataBind");

            PageMethods.getAvailableDockSpots(prodDetailsID, onSuccess_getAvailableDockSpots, onFail_getAvailableDockSpots, prodDetailsID);
        }
        function onFail_getAvailableLocations(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getAvailableLocations");
        }

        function onSuccess_updateLocation(value, newStatus, methodName) {

            hideMessages();
            var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");

            PageMethods.checkIfControlsCanBeUpdated(selectedProdDetailID, onSuccess_checkIfControlsCanBeUpdated, onFail_checkIfControlsCanBeUpdated);
            var InspectionListID = $("#cboxInspectionList").igCombo("value");
            if (selectedProdDetailID && InspectionListID) {
                var contextParam = [];
                contextParam["rebind"] = true;
                PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)
            }

            PageMethods.getTruckAndDataAvailableForInspections(selectedProdDetailID, onSuccess_getTruckAndDataAvailableForInspections, onFail_getTruckAndDataAvailableForInspections);
        }
        function onFail_updateLocation(value, ctx, methodName) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_updateLocation");
        }



        function onSuccess_getListofTrucksCurrentlyInZXPWithIncompleteTest(value, ctx, methodName) {
            var gridData = [];
            gridData.length = 0;
            for (i = 0; i < value.length; i++) {

                var isInspectionComplete = false;
                if (!checkNullOrUndefined(value[i][7])) {
                    isInspectionComplete = true;
                }
                var rejected = value[i][8];
                var rejectedText = '';
                if (rejected) {
                    rejectedText = 'Rejected';
                }
                var isFailed = value[i][11];
                gridData[i] = {
                    "MSID": value[i][0], "ETA": value[i][1], "PONUM": value[i][2], "TRAILNUM": value[i][3], "INSP": value[i][4], "LOCSTAT": value[i][5],
                    "LOCLONG": value[i][6], "INSPCLOSED": isInspectionComplete, "REJECTED": rejected, "REJECTEDTEXT": rejectedText, "ISFAILEDVALUE": isFailed,
                    "PRODID": value[i][12], "PRODDETAIL": value[i][13]
                };
            }
            $("#gridMissingResults").igGrid("option", "dataSource", gridData);
            $("#gridMissingResults").igGrid("dataBind");
        }

        function onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest(value, ctx, methodName) {
            sendtoErrorPage("Error in InspectionMobile.aspx, onFail_getListofTrucksCurrentlyInZXPWithIncompleteTest");
        }



        function onSuccess_setInspectionResult(value, ctx, method) {
            if (value) {
                //var timestamp = value[0];
                var rMsg = value[1];
                var hasEnded = value[2];
                var isLastQuestion = value[3];
                var rMsg = value[1];

                hideProgress();
                if ((hasEnded || isLastQuestion) && !checkNullOrUndefined(rMsg)) {
                    alert(rMsg);
                }
                var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
                var InspectionListID = $("#cboxInspectionList").igCombo("value");
                if (selectedProdDetailID && InspectionListID) {
                    var contextParam = [];
                    contextParam["rebind"] = true;
                    contextParam["closeInspectionDialog"] = (hasEnded || isLastQuestion);
                    contextParam["hasAnsweredQuestion"] = true;
                    PageMethods.getMSInspectionListAndData(selectedProdDetailID, InspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)
                }
            }
        }
        function onFail_setInspectionResult(value, ctx, method) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_setInspectionResult");
        }


        function onSuccess_getTruckAndDataAvailableForInspections(value, ctx, method) {
            if (value) {
                var currentDock = value[15];
                var currentSpotDesc = value[20];
                var currentSpotID = value[21];
                var fullLocation = (!checkNullOrUndefined(value[20])) ? currentDock + " - " + currentSpotDesc : currentDock;

                var truckData = {
                    "MSID": value[0], "ETA": value[1], "CUSTID": value[2], "TRUCKTYPE": value[3], "PO": value[4], "LOADSHORT": value[5], "TRAILNUM": value[6],
                    "DROP": value[7], "CABIN": value[8], "CABOUT": value[9], "CARRIER": value[10], "SHIP": value[11], "LOAD": value[12],
                    "REJECT": value[13], "REJECTREASON": value[14], "LOCLONG": fullLocation, "LOCSHORT": value[16], "STATUSID": value[17], "STATUSTEXT": value[18], "TIMEREJECTED": value[19],
                    "CURRENTSPOTTEXT": currentSpotDesc, "CURRENTSPOTID": currentSpotID

                };
                var pad = "00";

                //set drop trailer label
                var rDrop = truckData.DROP ? "YES" : "NO";
                $("#lblDrop").text($.trim(rDrop));

                //format ETA
                var d = new Date(truckData.ETA),
                    dHr = d.getHours(),
                    dMin = d.getMinutes(),
                    dSec = d.getSeconds(),
                    dformat = [(d.getMonth() + 1),
                    d.getDate(),
                    d.getFullYear()].join('/') + ' ' +
                    [d.getHours().padLeft(),
                    d.getMinutes().padLeft(),
                    d.getSeconds().padLeft()].join(':');
                $("#lblETA").text($.trim(dformat));

                //set labels
                $("#lblPO").text($.trim(String(truckData.PO)));
                $("#lblCurrentLocation").text(truckData.LOCLONG);
                $("#lblLoc").text(truckData.LOCLONG);
                $("#lblStat").text($.trim(truckData.STATUSTEXT));
                $("#lblStatus").text($.trim(truckData.STATUSTEXT));
                $("#lblTruckType").text($.trim(truckData.TRUCKTYPE));
                $("#lblLoad").text($.trim(truckData.LOAD));
                $("#lblTrailNum").text($.trim(truckData.TRAILNUM));
                $("#lblisRejected").text($.trim(truckData.REJECT ? "YES" : "NO"));
                $("#lblRejectTruck").text($.trim(truckData.REJECTREASON));

                $("#cboxLocationStatus").igCombo("value", truckData.LOCSHORT);

                if (truckData.LOCSHORT != "DOCKVAN" && truckData.LOCSHORT != "DOCKBULK") {
                    $("#dvLocDockSpot").hide();
                }


            }
        }
        function onFail_getTruckAndDataAvailableForInspections(value, ctx, method) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getTruckAndDataAvailableForInspections");
        }

        function onSuccess_getTruckAndProductList(value, ctx, method) {
            if (value) {
                var trucklist = [];
				var truckCounter = 0;
                for (i = 0; i < value.length; i++) {
					if(value[i]["TruckType"] === "Bulk"){
                    trucklist[truckCounter] = { "PODetailsID": value[i]["PODetailsID"], "TruckProdLabel": value[i]["TruckProdLabel"] };
					truckCounter++;
					}
                }
                $("#cboxTruckAndProdList").igCombo("option", "dataSource", trucklist);
                $("#cboxTruckAndProdList").igCombo("dataBind");
            }
        }
        function onFail_getTruckAndProductList(value, ctx, method) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getTruckAndProductList");
        }


        function onSuccess_getInspectionList(value, ctx, method) {
            if (value) {
                var defaultInspectionListID;

                var inspectionList = [];
                for (i = 0; i < value.length; i++) {
                    inspectionList[i] = { "InspectionListID": value[i][0], "InspectionListName": value[i][1] };
                    var check = 0;
                    if (0 === i) {
                        defaultInspectionListID = value[i][0];
                    }
                }

                $("#cboxInspectionList").igCombo("option", "dataSource", inspectionList);
                $("#cboxInspectionList").igCombo("dataBind");
                if (value.length > 0) {
                    $("#cboxInspectionList").igCombo("index", 0);
                    var selectedProdDetailID = $("#cboxTruckAndProdList").igCombo("value");
                    var contextParam = [];
                    contextParam["rebind"] = true;
                    PageMethods.getMSInspectionListAndData(selectedProdDetailID, defaultInspectionListID, onSuccess_getMSInspectionListAndData, onFail_getMSInspectionListAndData, contextParam)

                }
                else {
                    //bind to empty
                    $("#gridOfInspectionsUnderList").igGrid("option", "dataSource", []);
                    $("#gridOfInspectionsUnderList").igGrid("dataBind");
                    alert("No inspection list associated. Please contact the application adminstrator or IT department if a list should be added.");
                }
            }
        }
        function onFail_getInspectionList(value, ctx, method) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getInspectionList");
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
        function onSuccess_getMSInspectionListAndData(value, ctx, method) {
            if (value) {

                selectedInspectionListData = InspectionObject.bind({ 'inspectionListData': value });


                var checkRebind = !checkNullOrUndefined(ctx["rebind"]) && ctx["rebind"];
                if (checkRebind) {
                    var oInspectionList = selectedInspectionListData();
                    var oInspectionListDetails = [];
                    oInspectionListDetails = oInspectionList.InspectionListDetails; //List of available  Inspections
                    populateInspectionGridData(oInspectionListDetails);
                }

                var checkNeedsClose = !checkNullOrUndefined(ctx["closeInspectionDialog"]) && ctx["closeInspectionDialog"];
                if (checkNeedsClose) {
                    $("#dwInspectionQuestions").igDialog("close");
                }
                else {
                    var hasAnsweredQuestion = ctx["hasAnsweredQuestion"];
                    if (hasAnsweredQuestion == true) {
                        $(".down_nav").click();
                    }
                }
            }
            else {
                //bind to empty
                $("#gridOfInspectionsUnderList").igGrid("option", "dataSource", []);
                $("#gridOfInspectionsUnderList").igGrid("dataBind");
                alert("No inspections under list found. Please contact the application adminstrator or IT department if an inspection should be added.");
            }


        }

        function onFail_getMSInspectionListAndData(value, ctx, method) {
            sendtoErrorPage("Error in inspectionMobile.aspx, onFail_getMSInspectionListAndData");
        }

        function populateInspectionGridData(inspectionListDetails) {

            inspectionGridData = parseforInspectionGridData(inspectionListDetails);
            $("#gridOfInspectionsUnderList").igGrid("option", "dataSource", inspectionGridData);
            $("#gridOfInspectionsUnderList").igGrid("dataBind");
            var isDisabled = $("#gridOfInspectionsUnderList").data("isDisabled");
            if (isDisabled) {
                disableEditInspection();
            }

        }
        
     </script>
    
    
    <div><h2 style="display: inline">Select a Trailer - Product to Inspect</h2></div>
    <div> <input id="cboxTruckAndProdList" /></div>
    <h3 id="msgUpdateTruck" style="display: none; color: red;">Cannot update truck location because of current status</h3>
    <h3 id="msgEditInspection" style="display: none; color: red;">Cannot Edit Inspection because of current status or location</h3>
    
    <br />
    <div id="dvSectionTrailerDetails" class="dvOutline dvLightGrey" style="width: 95%;">
        <div>

            <img id ="dvTrailerDetails-Plus" src ="Images/plus-sign.png" class="mi4-expandable-click"  onclick="toggleDisplayItem('dvTrailerDetails-Plus');toggleDisplayItem('dvTrailerDetails-Minus'); toggleDisplayItem('dvTrailerDetails'); return false;"/>
            <img id ="dvTrailerDetails-Minus" src ="Images/minus-sign.png" class="mi4-expandable-click" style="display:none" onclick="toggleDisplayItem('dvTrailerDetails-Plus');toggleDisplayItem('dvTrailerDetails-Minus'); toggleDisplayItem('dvTrailerDetails'); return false;"/>
           <%--<div class="mi4-expandable-click" onclick="toggleDisplayItem('dvTrailerDetails')"></div>--%>
            <h2 class="sectionHeaderStyling" >View Trailer Details<span id="spPOProdDetail1"></span></h2>
        </div>
        <div id="dvTrailerDetails" style="display:none" >
            <table class="tblTruckDetailsStyle">
                <tr>
                    <td class="col1_of_4" id="">PO:</td>
                    <td class="col2_of_4"><span id="lblPO"></span></td>
                    <td class="col3_of_4">Current Location:</td>
                    <td class="col4_of_4"><span id="lblCurrentLocation"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Trailer:</td>
                    <td class="col2_of_4"><span id="lblTrailNum"></span></td>
                    <td class="col3_of_4">Current Status:</td>
                    <td class="col4_of_4"><span id="lblStatus"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">ETA:</td>
                    <td class="col2_of_4"><span id="lblETA"></span></td>
                    <td class="col3_of_4">Truck Type:</td>
                    <td class="col4_of_4"><span id="lblTruckType"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Drop Trailer:</td>
                    <td class="col2_of_4"><span id="lblDrop"></span></td>
                    <td class="col3_of_4">Load Type:</td>
                    <td class="col4_of_4"><span id="lblLoad"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4" >Rejected?:</td>
                    <td colspan ="3"><span id="lblisRejected"></span></td>
                </tr>
                <tr>
                    <td class="col1_of_4">Rejected Comments:</td>
                    <td colspan="3"> <span id="lblRejectTruck"></span></td>
                </tr>
            </table>
        </div>
    </div>

    <br />

    <div id="dvSectionUpdateTruckLocation" class="dvOutline dvLightGrey" style="width: 95%;" >
        <div>
            <img id ="dvUpdateTruckLocation-Plus" src ="Images/plus-sign.png" class="mi4-expandable-click"   onclick="toggleDisplayItem('dvUpdateTruckLocation-Plus');toggleDisplayItem('dvUpdateTruckLocation-Minus'); toggleDisplayItem('dvUpdateTruckLocation'); return false;"/>
            <img id ="dvUpdateTruckLocation-Minus" src ="Images/minus-sign.png" class="mi4-expandable-click" style="display:none"  onclick="toggleDisplayItem('dvUpdateTruckLocation-Plus');toggleDisplayItem('dvUpdateTruckLocation-Minus'); toggleDisplayItem('dvUpdateTruckLocation'); return false;"/>
            <%--<div class="mi4-expandable-click" onclick="toggleDisplayItem('dvUpdateTruckLocation')"></div>--%>
            
            <h2 class="sectionHeaderStyling" >Update Truck Location<span id="spPOProdDetail2"></span></h2>
        </div>
        
        <div id="dvUpdateTruckLocation" style="display:none;">
        <div>
            <h3 class="sectionHeaderStyling">Update the location to where the truck/trailer is currently being inspected</h3>
        </div>
            <table class="tblTruckDetailsStyle">
                <tr>
                    <td class="col1_of_2">Current Location:</td>
                    <td class="col2_of_2">
                        <label id="lblLoc" style="color: blue"></label>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">Current Status:</td>
                    <td class="col2_of_2">
                        <label id="lblStat" style="color: blue"></label>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">New Location:</td>
                    <td class="col2_of_2">
                        <div id="dvLocStat" style="display: inline; vertical-align: middle">
                            <div class="mi4-element-hidden-before-selection">
                                <input id="cboxLocationStatus"/></div>
                            <div class="mi4-element-hidden-before-selection">
                                <input id="btnUpdateLocation" type="button" class="mi4-updateLocation" onclick="onclick_UpdateLocation()" value="Update" /></div>
                        </div>
                    </td>
                </tr>
                <tr>
                    <td class="col1_of_2">New Dock Spot:</td>
                    <td class="col2_of_2">
                        <div id="dvLocDockSpot" style="display: inline; vertical-align: middle">
                            <div class="mi4-element-hidden-before-selection">
                                <input id="cboxDockSpots"/></div>
                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
<%--    <div id="dvRejectTruck" class="dvOutline dvLightGrey" style="width: 100%;">
        <h2 class="sectionHeaderStyling">Reject Truck<span id="spPOProdDetail3"></span></h2>
        <div class="dvHideShowButtons"></div>
    </div>--%>
    
    <br />
    <div id="dvSectionInspections" class="dvOutline dvLightGrey" style="width:95%">
        <h2 class="sectionHeaderStyling">Inspections<span id="spPOProdDetail3"></span></h2>
        <div><input id="cboxInspectionList" /></div>
        <%--Inspections Under List --%>
        <table id="gridOfInspectionsUnderList" class="scrollGridClass"></table>
    </div>
    
    <br />
    <div id="dvSectionMissingResults" class="dvOutline dvLightGrey" style="width: 95%;">
        <div>
            <img id ="dvMissingResults-Plus" src ="Images/plus-sign.png" class="mi4-expandable-click"   onclick="toggleDisplayItem('dvMissingResults-Plus');toggleDisplayItem('dvMissingResults-Minus'); toggleDisplayItem('dvMissingResults'); return false;"/>
            <img id ="dvMissingResults-Minus" src ="Images/minus-sign.png" class="mi4-expandable-click" style="display:none"  onclick="toggleDisplayItem('dvMissingResults-Plus');toggleDisplayItem('dvMissingResults-Minus'); toggleDisplayItem('dvMissingResults'); return false;"/>
            <%--<div class="mi4-expandable-click" onclick="toggleDisplayItem('dvMissingResults')"></div>--%>
            <h2 class="sectionHeaderStyling">Trucks with Incomplete Test<span id="spPOProdDetail4"></span></h2>
        </div>
       
         <div id="dvMissingResults" style="display:none;">
            <div>
                Filter Grid Results 
                <span id="Div1"><input type="button" onclick="onclick_ShowAllTrucks(); return false;" value="Show All" /><input type="button" onclick="    onclick_ShowTodayOnly(); return false;" value="Show Today Only" /></span>
            </div>
            <table id="gridMissingResults" class="scrollGridClass"></table>
        </div>


    </div>
    

    <%-----------------------------------------------------------------------------------%>
    <%--UPLOAD
    <%-----------------------------------------------------------------------------------%>
    <div id="dvUploadsContainer" style='display: none;'>
        <input type="file" style='display: none;' id="igUploadIMAGE" class="CameraUpload" accept="image/*" capture='camera'>
    </div>


    
    <%-----------------------------------------------------------------------------------%>
    <%-- DIALOG/ POP UPS --%>
    <%-----------------------------------------------------------------------------------%>
    <%--InspectionQuestions Dialog--%>
    <div id="dwInspectionQuestions">
            <div id="dvNavUp" class="dv_nav"><button class="btn_nav up_nav">Previous Question</button></div>
            <h3>Note: Answers are automatically saved.</h3> 
            <div class="dv_questionsArea">
                <div id="dvQuestionsArea"></div>
                <br /><br />
                <div><input type='button' value='Close Windows' onclick='closeIGDialog("dwInspectionQuestions")'/></div>
            </div>
            
            <div id="dvNavDown" class="dv_nav"><button class="btn_nav down_nav" >Next Question</button></div>
    </div>


    <%--InspectionDetails Dialog--%>
    <div id="dwInspectionDetails">
        <div>
            <div class ="detailBox">
                <h2><span>Inspection Details:  <span id="Span1"></span></span></h2>
                <table>
                    <tr><td>Last Edited By: </td><td><span id="spInspDetailLastEditedBy"></span></td></tr>
                    <tr><td>Time Last Edited: </td><td><span id="spInspDetailTimeLastEditedBy"></span></td></tr>
                    <tr><td>Inspection Started By: </td><td><span id="spInspDetailCreatedBy"></span></td></tr>
                    <tr><td>Time Started: </td><td><span id="spInspDetailTimeStart"></span></td></tr>
                    <tr><td>Time Completed: </td><td><span id="spInspDetailTimeEnd"></span></td></tr>
                    <tr id="trVerifiedDetail"><td>Verified by:</td><td><span id="spInspDetailVerifiedBy"></span></td></tr>
                </table>
            </div>
            <br />
            <div class ="detailBox">
                <h2><span>Truck Files:  <span id="POTrailer_dwFileUpload"></span></span></h2>
                <div class="ContentExtend">
                    <table id="gridFiles" class="ContentExtend"></table>
                </div>
            </div>
            <br />
            <div class ="detailBox">
                <h2><span>Comments:  <span id="Span2"></span></span></h2>
                <div style="width:100%">
                    <div><textarea id="txtInspDetailComments" style="width:90% !important; max-width:90% !important"></textarea></div>
                    <div><div  style="clear:right; overflow: auto"><input type='button' class="mi4-editInspection" value='Save Comment' onclick='saveComment()'/></div><div style="float:left;"><label id="lblSaving" style="display:none">Saving...</label></div></div>
                </div>
             </div>
        </div>
        <div><input type='button' value='Close' class="mi4-dialog-close-button" onclick='closeIGDialog("dwInspectionDetails")'/></div>
    </div>

</asp:Content>
