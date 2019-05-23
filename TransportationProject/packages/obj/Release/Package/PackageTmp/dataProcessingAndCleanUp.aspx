<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="dataProcessingAndCleanUp.aspx.cs" Inherits="TransportationProject.dataProcessingAndCleanUp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FeaturedContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server" EnablePageMethods="true"></asp:ScriptManager>
    <script type="text/javascript">

        function onClick_UpdateVolumeData() {
            showProgress();
            PageMethods.updateTanksWithCurrentVolumesFromCMS(onSuccess_updateTanksWithCurrentVolumesFromCMS, onFail_updateTanksWithCurrentVolumesFromCMS);
        };

        function onClick_UpdatePOStatus() {
            showProgress();
            PageMethods.updateIsOpenInCMSStatus(onSuccess_updateIsOpenInCMSStatus, onFail_updateIsOpenInCMSStatus);
        };
        function onSuccess_updateTanksWithCurrentVolumesFromCMS(values, ctx, methodName) {
            if (values) {
                var specialTanksCount = values[0];
                var mismatchUnitCount = values[1];

                var msg = "";
                if (specialTanksCount > 0) {
                    msg = msg + "Some tanks volumes were not updated because some tanks have more than one product associated or the product associated can be split and placed into multiple tanks. ";
                }
                if (mismatchUnitCount > 0) {
                    msg = msg + "Some tank volumes were not updated because the units in CMS for the product is not in 'GAL'";
                }
                hideProgress();
                if (!checkNullOrUndefined(msg)) {
                    alert(msg);
                }

            }
        }
        function onSuccess_updateIsOpenInCMSStatus(values, ctx, methodName) {
            hideProgress();
            if (values) {
                var POList = values;
                var sPO = "";
                if (typeof POList === "object") {
                    if (POList.length > 0) {
                        sPO = POList[0]; //initiate with first value
                        for (i = 1; i < POList.length; i++) { //start concat with 2nd val
                            sPO = sPO + ", " + POList[i];
                        }
                        alert( "There are PO's with drop trailers that could not be updated because they are not emptied. PO's with non-emptied drop trailer: " + sPO + "");
                    }
                    else {
                        alert("Truck Schedule PO statuses updated.");
                    }
                }
            }
        }


        function onFail_updateIsOpenInCMSStatus(values, ctx, methodName) {
            hideProgress();
            sendtoErrorPage("Error in dataProcessingAndCleanUP.aspx onFail_updateIsOpenInCMSStatus");

        }

        function onFail_updateTanksWithCurrentVolumesFromCMS(values, ctx, methodName) {
            hideProgress();
            sendtoErrorPage("Error in dataProcessingAndCleanUP.aspx onFail_updateTanksWithCurrentVolumesFromCMS");

        }
    </script>
    <h1>Data Processing and Clean Up Page</h1>
    
    <h2>Update Tank Volumes</h2>
    <h3><span id="Span2">
        <p>Update Tank Volumes based on current quantity retrieved from CMS</p>
        <button type="button" id="btnUpdateTankVolume" onclick ="onClick_UpdateVolumeData();return false;">Manually Update Current Tank Volumes</button>
        </span>
    </h3>
    <h2>Update Is Open In CMS</h2>
    <h3><span id="Span1">
        <p>Update to close PO Order based on status retrieved from CMS.</p>
        <button type="button" id="btnUpdatePOStatus" onclick ="onClick_UpdatePOStatus();return false;">Manually Update PO Status</button>
        </span>
    </h3>
    
</asp:Content>
