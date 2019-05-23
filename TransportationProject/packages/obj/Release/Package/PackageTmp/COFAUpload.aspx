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


         function onSuccess_getGridData(value, ctx, methodName) {
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
         function onSuccess_getGridDataRebind(value, ctx, methodName) {
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

         function onFail_getGridData(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_getGridData");
         }

         function onSuccess_deleteFileDBEntry(value, ctx, methodName) {
             PageMethods.getGridData(onSuccess_getGridDataRebind, onFail_getGridData);
             hideProgress();
             var MSID = $("#grid").data("data-MSID");
             PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
         }

         function onFail_deleteFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_deleteFileDBEntry");
         }

         function onSuccess_processFileAndData(returnData, passedData, methodName) {
             if (passedData) {
                 if ("COFA" === passedData[1]) {
                     //Add entry into DB
                     PageMethods.addFileDBEntry(passedData[2], "COFA", passedData[0], returnData[1], returnData[0], "COFA", passedData[3], onSuccess_addFileDBEntry, onFail_addFileDBEntry, passedData);
                 }
             }
         }

         function onFail_processFileAndData(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_processFileAndData");
         }

         function onSuccess_addFileDBEntry(value, passedData, methodName) {
             PageMethods.getGridData(onSuccess_getGridDataRebind, onFail_getGridData);
             hideProgress();
             var MSID = $("#grid").data("data-MSID");
             PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
         }

         function onFail_addFileDBEntry(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_addFileDBEntry");
         }
         function onSuccess_getLogDataByMSID(returnValue, MSID, methodName) {
             truckLog_OnSuccess_Render(returnValue, MSID);
         }

         function onFail_getLogDataByMSID(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx onFail_getLogDataByMSID");
         }

         function onSuccess_getLogList(value, ctx, methodName) {
             if (value.length > 0) {
                 for (var i = 0; i < value.length; i++) {
                     var POTrailerCombo = comboPOAndTrailer(value[i][1], value[i][2]);
                     GLOBAL_LOG_OPTIONS.push({ "MSID": value[i][0], "PO": POTrailerCombo });
                 }
                 $("#cboxLogTruckList").igCombo("option", "dataSource", GLOBAL_LOG_OPTIONS);
                 $("#cboxLogTruckList").igCombo("dataBind");
             }
         }

         function onFail_getLogList(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx onFail_getLogList");
         }

         function onSuccess_setCOFAComment(value, MSID, methodName) {
             $("#grid").igGrid("commit");
             PageMethods.getLogDataByMSID(MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, MSID);
         }

         function onFail_setCOFAComment(value, ctx, methodName) {
             sendtoErrorPage("Error in COFAUpload.aspx, onFail_setCOFAComment");
         }

         <%-------------------------------------------------------
        Button Click Handlers
        -------------------------------------------------------%>
         function onclick_addFile(fupID, MSID, SampleID) {
             $("#grid").data("data-someButtonClicked", true);
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-SampleID", SampleID);
             $(fupID).click();
         }

         function onclick_deleteCOFA(SampleID, PODetailID, PO, Product, MSID) 
         {
             $("#grid").data("data-MSID", MSID);
             $("#grid").data("data-SampleID", SampleID);
             $("#grid").data("data-someButtonClicked", true);
             r = confirm("Continue removing the COFA from truck with PO: " + PO + " Product: " + String(Product).trim() + "? This cannot be undone.")
             if (r) {
                 PageMethods.deleteFileDBEntry(SampleID, MSID, onSuccess_deleteFileDBEntry, onFail_deleteFileDBEntry);
             }
         }
         $(function () {
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
                         PageMethods.getLogDataByMSID(ui.items[0].data.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, ui.items[0].data.MSID);
                     }
                     else if (ui.items.length == 0) {
                         $("#tableLog").empty();
                     }
                 }
             });

             PageMethods.getLogList(onSuccess_getLogList, onFail_getLogList);
             PageMethods.getGridData(onSuccess_getGridData, onFail_getGridData);

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
                     PageMethods.processFileAndData(ui.filePath, "COFA", onSuccess_processFileAndData, onFail_processFileAndData, passVal);
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
                              headerText: "Rejected", key: "REJECTED", dataType: "boolean", template: "{{if(${REJECTED})}}" +
                               "<div class ='needsTruckMove'>Rejected</div>{{else}}<div></div>{{/if}}", width: "65px"
                         },
                         { headerText: "Is open in CMS", key: "isOpenInCMS", dataType: "string", width: "50px" },
                         { headerText: "", key: "PODETAILID", dataType: "number", width: "0px", hidden: true },
                         { headerText: "", key: "FILEID", dataType: "number", width: "0px", hidden: true },
                         { headerText: "", key: "FILENAME", dataType: "string", width: "0px", hidden: true },
                         { headerText: "", key: "FUPLOAD", dataType: "string", width: "0px", hidden: true },
                         { headerText: "MSID", key: "MSID", dataType: "string", width: "50px" },
                         { headerText: "Sample ID", key: "SAMPLEID", dataType: "string", width: "75px" }, <%--must remain as string due to filtering from Samples--%>
                         { headerText: "PO", key: "PO", dataType: "string", width: "100px" },
                         { headerText: "Trailer #", key: "TRAILER", dataType: "string", width: "150px" },
                         { headerText: "Product IDs", key: "PRODUCTS", dataType: "string", width: "150px" },
                         { headerText: "Product", key: "PRODUCTDETAILS", dataType: "string", width: "150px" },
                         {
                             headerText: "COFA", key: "FILEUPLOAD", dataType: "string", width: "250px",
                             template: "{{if (checkNullOrUndefined(${FILENAME})) ===true}} <div id='dCOFAcontainer'class ='ColumnContentExtend' data-fileID='${FILEID}'  style='float:left; background-color:lightcoral;'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div><div style='float:right'><div id='dDelCOFA'>" +
                                 "<img src='Images/xclose.png' onclick='onclick_deleteCOFA(${SAMPLEID}, ${PODETAILID}, ${PO}, \"${PRODUCTS}\", ${MSID});return false;' height='16' width='16'/></div><div id='dUpCOFA'class='uploadCOFA'>" +
                                 "<img src='Images/triangleDown.png' onclick='onclick_addFile(\"#igUploadCOFA_ibb_fp\", ${MSID}, ${SAMPLEID});return false;' height='16' width='16' /></div></div> </div>" +
                                 "{{else}} <div id='dCOFAcontainer' data-fileID='${FILEID}'  style='float:left'><a id='alinkCOFA' href='${FUPLOAD}'>${FILENAME}</a></div><div style='float:right'><div id='dDelCOFA'>" +
                                 "<img src='Images/xclose.png' onclick='onclick_deleteCOFA(${SAMPLEID}, ${PODETAILID}, ${PO}, \"${PRODUCTS}\", ${MSID});return false;' height='16' width='16'/></div><div id='dUpCOFA'class='uploadCOFA'>" +
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
                              PageMethods.getLogDataByMSID(row.MSID, onSuccess_getLogDataByMSID, onFail_getLogDataByMSID, row.MSID);
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
             

             <%--filtering from when coming from Guard Stat page on button click --%>
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
     </script>
    <%-------------------------------------------------------
        HTML SECTION
        -------------------------------------------------------%>
    <div class="logWindow" >
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
    <table id="grid"></table>
    <div id="igUploadCOFA" style='display: none;' ></div> 
</asp:Content>
