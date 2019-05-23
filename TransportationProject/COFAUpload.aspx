<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="COFAUpload.aspx.cs" Inherits="TransportationProject.COFAUpload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Upload COFA</h2>
    <h3>View, upload, and delete COFA files.</h3>
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
     <script type="text/javascript">
        <%-------------------------------------------------------
        Globals
        -------------------------------------------------------%>
         var GLOBAL_GRID_DATA = [];
         var GLOBAL_REJECT_DECISION = false;
         var GLOBAL_LOG_OPTIONS = [];

        
        <%-------------------------------------------------------
        Pagemethods Handlers
        //-------------------------------------------------------%>


         function onSuccess_GetGridData(value, ctx, methodName) {
             if (value) {
                 GLOBAL_GRID_DATA = [];
                 var productString = "";
                 for (var i = 0; i < value.length; i++) {
                     var product = value[i][5].trim();
                     var isOpenInCMS = formatBoolAsYesOrNO(value[i][11]);

                     GLOBAL_GRID_DATA.push({
                         "PODETAILID": value[i][0], "SAMPLEID": value[i][1], "MSID": value[i][2], "PO": value[i][3], "TRAILER": value[i][4], "PRODUCTS": product,
                         "FILEID": value[i][6], "FUPLOAD": value[i][7] + "/" + value[i][9], "FILENAME": value[i][8], "COFACOMMENT": value[i][10],
                         "isOpenInCMS": isOpenInCMS, "REJECTED": value[i][12], "PRODUCTDETAILS": value[i][13]
                     });
                 }
             }
             initGrid();
             if (!ctx) {
             }
             else {
                 $("#grid").igGrid("dataBind");
                 $("#grid").igGrid("commit");
             }
         }
         function onSuccess_GetGridDataRebind(value, ctx, methodName) {
             $("#grid").data("data-MSID", "");
             $("#grid").data("data-SampleID", "");
             $("#grid").data("data-someButtonClicked", "");
             if (value) {
                 GLOBAL_GRID_DATA = [];
                 var productString = "";
                 for (var i = 0; i < value.length; i++) {
                     var product = value[i][5].trim();
                     var isOpenInCMS = formatBoolAsYesOrNO(value[i][11]);

                     GLOBAL_GRID_DATA.push({
                         "PODETAILID": value[i][0], "SAMPLEID": value[i][1], "MSID": value[i][2], "PO": value[i][3], "TRAILER": value[i][4], "PRODUCTS": product,
                         "FILEID": value[i][6], "FUPLOAD": value[i][7] + "/" + value[i][9], "FILENAME": value[i][8], "COFACOMMENT": value[i][10],
                         "isOpenInCMS": isOpenInCMS, "REJECTED": value[i][12], "PRODUCTDETAILS": value[i][13]
                     });
                 }
                 $("#grid").igGrid("option", "dataSource", GLOBAL_GRID_DATA); <%--rebind invalid datagrid to new data--%>
                 $("#grid").igGrid("dataBind"); <%--rebind invalid datagrid to new data--%>
             }
         }

         function onFail_GetGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_GetGridData");
         }

         function onSuccess_DeleteFileDBEntry(value, ctx, methodName) {
             PageMethods.GetGridData(onSuccess_GetGridDataRebind, onFail_GetGridData);
             hideProgress();
             var MSID = $("#grid").data("data-MSID");
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }

         function onFail_DeleteFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_DeleteFileDBEntry");
         }

         function onSuccess_ProcessFileAndData(returnData, passedData, methodName) {
             if (passedData) {
                 if ("COFA" === passedData[1]) {
                     //Add entry into DB
                     PageMethods.AddFileDBEntry(passedData[2], "COFA", passedData[0], returnData[1], returnData[0], "COFA", passedData[3], onSuccess_AddFileDBEntry, onFail_AddFileDBEntry, passedData);
                 }
             }
         }

         function onFail_ProcessFileAndData(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_ProcessFileAndData");
         }

         function onSuccess_AddFileDBEntry(value, passedData, methodName) {
             PageMethods.GetGridData(onSuccess_GetGridDataRebind, onFail_GetGridData);
             hideProgress();
             var MSID = $("#grid").data("data-MSID");
             //PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }

         function onFail_AddFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_AddFileDBEntry");
         }
         function onSuccess_GetLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }

         function onFail_GetLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx onFail_GetLogDataByMSID");
         }

         function onSuccess_GetLogList(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);
                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                 }
                 $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                 $("#cboxLogTruckList").igCombo("dataBind");
             }
         }

         function onFail_GetLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx onFail_GetLogList");
         }

         function onSuccess_setCOFAComment(value, MSID, methodName) {
             $("#grid").igGrid("commit");
            // PageMethods.GetLogDataByMSID(MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, MSID);
         }

         function onFail_setCOFAComment(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_setCOFAComment");
         }

         function onSuccess_checkIfCOFAcanBeDeleted(returnValue, sampleDataForDelete, methodName) {
             if (returnValue[0] == "true") {
                 onclick_deleteCOFA(sampleDataForDelete[0], sampleDataForDelete[1], sampleDataForDelete[2], sampleDataForDelete[3], sampleDataForDelete[4]);
             }
             else {
                 alert(returnValue[1]);
             }
         }

         function onFail_checkIfCOFAcanBeDeleted(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_checkIfCOFAcanBeDeleted");
         }
         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>
         function onclick_returnToSamples(samplesID)
         {
             sessionStorage.setItem('sampleID', samplesID);
             location.href = 'Samples.aspx';
         }
         function onclick_addFile(fupID, MSID, SampleID) {
             $("#grid").data("data-someButtonClicked", true);
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-SampleID", SampleID);
             $(fupID).click();
         }

         function onclick_checkIfCOFACanBeDeleted(SampleID, PODetailID, PO, Product, MSID) {
             $("#grid").data("data-someButtonClicked", true);
             var sampleDataForDelete = [SampleID, PODetailID, PO, Product, MSID];
             PageMethods.checkIfCOFAcanBeDeleted(MSID, SampleID, onSuccess_checkIfCOFAcanBeDeleted, onFail_checkIfCOFAcanBeDeleted, sampleDataForDelete);

         }
         function onclick_deleteCOFA(SampleID, PODetailID, PO, Product, MSID) 
         {
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-SampleID", SampleID);
             $("#grid").data("data-someButtonClicked", true);
             r = confirm("Continue removing the COFA from truck with PO: " + PO + " Product: " + String(Product).trim() + "? This cannot be undone.")
             if (r) {
                 PageMethods.DeleteFileDBEntry(SampleID, MSID, onSuccess_DeleteFileDBEntry, onFail_DeleteFileDBEntry);
             }
         }
         $(function () {
             $(".arrowGridScrollButtons").show();
             var isMobile = isOnMobile();
             $("#logButton").click(function () {
                 var logDisplay = $('#logTableWrapper').css('display');
                 truckLog_MiniMaxAndRemember(logDisplay);
             });

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
             PageMethods.GetGridData(onSuccess_GetGridData, onFail_GetGridData);

             $("#igUploadCOFA").igUpload({
                 autostartupload: true,
                 progressUrl: "~/IGUploadStatusHandler.ashx",
                 fileSelected: function (evt, ui) { showProgress(); },
                 fileUploaded: function (evt, ui) {
                     var MSID = $("#grid").data("data-MSID");

                    <%-- call pagemethod to process file and data--%>
                     var passVal = [];
                     var SampleID = $("#grid").data("data-SampleID");
                     passVal[0] = ui.filePath;
                     passVal[1] = "COFA";
                     passVal[2] = MSID;
                     passVal[3] = SampleID;
                     PageMethods.ProcessFileAndData(ui.filePath, "COFA", onSuccess_ProcessFileAndData, onFail_ProcessFileAndData, passVal);
                     hideProgress();
                 },
                 fileUploadedAborted: function (evt, ui) {
                     hideProgress();
                 },
                 onError: function (evt, ui) {
                     hideProgress();
                     sendtoErrorPage("Error in COFAUpload.aspx, igUploadCOFA");
                 },

             });
         }); <%--end $(function () --%>



         <%-------------------------------------------------------
         Initialize Infragistics IgniteUI Controls
         -------------------------------------------------------%>
         function initGrid() {
             $("#grid").igGrid({
                 dataSource: GLOBAL_GRID_DATA,
                 width: "100%",
                 virtualization: false,
                 autoGenerateColumns: false,
                 renderCheckboxes: true,
                 primaryKey: "SAMPLEID",
                 columns:
                     [
                    {
                        headerText: "Return to Samples", key: "SAMPLES", dataType: "string", width: "150px",
                        template: "<div class ='ColumnContentExtend'><input id='btnUpCOFA' type='button' value='To Samples Page' onclick='onclick_returnToSamples(${SAMPLEID});' class='ColumnContentExtend'></div>"
                    },
                         {
                              headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED})}}" +
                               "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "65px"
                         },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", dataType: "string", width: "0px" },
                         { headerText: "", key: "PODETAILID", dataType: "number", width: "0px", hidden: true },
                         { headerText: "", key: "FILEID", dataType: "number", width: "0px", hidden: true },
                         { headerText: "", key: "FILENAME", dataType: "string", width: "0px", hidden: true },
                         { headerText: "", key: "FUPLOAD", dataType: "string", width: "0px", hidden: true },
                         { headerText: "MSID", key: "MSID", dataType: "string", width: "0px" },
                         { headerText: "Sample ID", key: "SAMPLEID", dataType: "string", width: "0px" }, <%--must remain as string due to filtering from Samples--%>
                         { headerText: "PO", key: "PO", dataType: "string", width: "100px" },
                         { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                         { headerText: "Product IDs", key: "PRODUCTS", dataType: "string", width: "150px" },
                         { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "150px" },
                         {
                             headerText: "COFA", key: "FILEUPLOAD", dataType: "string", width: "250px",
                             template: "{{if (checkNullOrUndefined(${FILENAME})) ===true}} <div id='dCOFAcontainer'class ='ColumnContentExtend' data-fileID='${FILEID}'  style='float:left; background-color:lightcoral;'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div><div style='float:right'><div id='dDelCOFA'>" +
                                 "<img src='Images/xclose.png' onclick='onclick_checkIfCOFACanBeDeleted(${SAMPLEID}, ${PODETAILID}, ${PO}, \"${PRODUCTS}\", ${MSID});return false;' height='16' width='16'/></div><div id='dUpCOFA'class='uploadCOFA'>" +
                                 "<img src='Images/triangleDown.png' onclick='onclick_addFile(\"#igUploadCOFA_ibb_fp\", ${MSID}, ${SAMPLEID});return false;' height='16' width='16' /></div></div> </div>" +
                                 "{{else}} <div id='dCOFAcontainer' data-fileID='${FILEID}'  style='float:left'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div><div style='float:right'><div id='dDelCOFA'>" +
                                 "<img src='Images/xclose.png' onclick='onclick_checkIfCOFACanBeDeleted(${SAMPLEID}, ${PODETAILID}, ${PO}, \"${PRODUCTS}\", ${MSID});return false;' height='16' width='16'/></div><div id='dUpCOFA'class='uploadCOFA'>" +
                                 "<img src='Images/triangleDown.png' onclick='onclick_addFile(\"#igUploadCOFA_ibb_fp\", ${MSID}, ${SAMPLEID});return false;' height='16' width='16' /></div></div>{{/if}}"
                         },
                         { headerText: "Comment", key: "COFACOMMENT", dataType: "string" }
                     ],
                 features: [
                      {
                          name: 'Updating',
                          enableAddRow: false,
                          editMode: "row",
                          enableDeleteRow: false,
                          autoCommit: false,
                          editRowStarting: function (evt, ui) {
                              var row = ui.owner.grid.findRecordByKey(ui.rowID);
                              //PageMethods.GetLogDataByMSID(row.MSID, onSuccess_GetLogDataByMSID, onFail_GetLogDataByMSID, row.MSID);

                              var isUploadBtnClicked = $("#grid").data("data-BUTTONClick");
                              if (isUploadBtnClicked) {
                                  $("#grid").data("data-BUTTONClick", false);
                                  return false;
                              }
                          },
                          editRowEnding: function (evt, ui) {
                              var origEvent = evt.originalEvent;
                              if (typeof origEvent === "undefined") {
                                  ui.keepEditing = true;
                                  return false;
                              }
                              if (ui.update == true && ui.rowAdding == false && ((evt.originalEvent.type == "click" && evt.originalEvent.currentTarget.innerText == "Done") || evt.keyCode == 13)) {
                                  var row = ui.owner.grid.findRecordByKey(ui.rowID);
                                  //if (checkNullOrUndefined(ui.values.COFACOMMENT) == true) {
                                      //alert("Comment can not be empty");
                                      //return false;
                                  //}
                                  //else {
                                      PageMethods.setCOFAComment(row.SAMPLEID, ui.values.COFACOMMENT, onSuccess_setCOFAComment, onFail_setCOFAComment, row.MSID);
                                  //}
                              }
                          },
                          columnSettings:
                              [
                                  { columnKey: "SAMPLES", readOnly: true },
                                  { columnKey: "PRODUCTDETAILS", readOnly: true },
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                  { columnKey: "REJECTED", readOnly: true },
                                  { columnKey: "isOpenInCMS", readOnly: true },
                                  { columnKey: "SAMPLEID", readOnly: true },
                                  { columnKey: "MSID", readOnly: true },
                                  { columnKey: "PO", readOnly: true },
                                  { columnKey: "TRAILER", readOnly: true },
                                  { columnKey: "PRODUCTS", readOnly: true },
                                  { columnKey: "FILEUPLOAD", readOnly: true }
                              ],
                      },
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
                       }
                 ]
             }); <%--end of $("#grid").igGrid({--%>


             $(document).delegate("#grid", "iggridcellclick", function (evt, ui) {
                 if (ui.colKey === 'SAMPLES' ) {
                     $("#grid").data("data-BUTTONClick", true);
                 }
                 else {
                     $("#grid").data("data-BUTTONClick", false);
                 }
             });


             <%--filtering from when coming from samples page on button click --%>
             var sampleID = sessionStorage.getItem("sampleID");
             if (checkNullOrUndefined(sampleID) == false) {
                 $("#grid").igGridFiltering("filter", ([{
                     fieldName: "SAMPLEID",
                     expr: sampleID.toString(),
                     cond: "equals"
                 }]), true);
                 sessionStorage.setItem('sampleID', "");<%--reset filter --%>
             }
             

             <%--filtering from when coming from Guard Station page on button click --%>
             var PO = sessionStorage.getItem("PO");
             if (checkNullOrUndefined(PO) == false) {
                 $("#grid").igGridFiltering("filter", ([{
                     fieldName: "PO",
                     expr: PO.toString(),
                     cond: "equals"
                 }]), true);
                 sessionStorage.setItem('PO', "");<%--reset filter --%>
             }
         }
         
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
    <table id="grid" class="scrollGridClass"></table>
    <div id="igUploadCOFA" style='display: none;' ></div> 
</asp:Content>
