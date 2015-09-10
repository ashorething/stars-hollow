﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Dashboard.master" AutoEventWireup="true" CodeBehind="DashboardPersonal.aspx.cs" Inherits="BD_Web_Group_Project_Webpages_v1.DashboardPersonal" %>
<asp:Content ID="cphStarsHollowBody" ContentPlaceHolderID="cphDashboardMain" runat="server">

    <!-- This page is for the user to input in the rest of their personal details 
        following initial registration. -->

        <h4>Edit Personal Details</h4>
        <br />
        <div class="detailsBox">
            <asp:Label ID="lblLocation" runat="server" Text="Location "></asp:Label>
            <asp:TextBox ID="txtLocation" runat="server"></asp:TextBox>
            <asp:RegularExpressionValidator ID="regxvLocation" runat="server" ControlToValidate="txtLocation" Display="Dynamic" CssClass="validator" ValidationExpression="[A-Za-z0-9\s\,\.\-]+" ValidationGroup="vgRegisterPage1"><br />Your location may only contain the following characters: <br /> [A-Z] [a-z] [0-9] [space] [,] [.] [-]</asp:RegularExpressionValidator>
            <br />
            <br />
            <asp:Label ID="lblProfesssion" runat="server" Text="Profession "></asp:Label>
            <asp:TextBox ID="txtProfession" runat="server"></asp:TextBox>
            <asp:RegularExpressionValidator ID="regxvProfession" runat="server" ControlToValidate="txtProfession" Display="Dynamic" CssClass="validator" ValidationExpression="[A-Za-z\s\-]+" ValidationGroup="vgRegisterPage1"><br />Your profession may only contain the following characters: <br /> [A-Z] [a-z] [space] [-]</asp:RegularExpressionValidator>
            <br />
            <br />
            <asp:Label ID="lblGender" runat="server" Text="Gender "></asp:Label>
            <asp:DropDownList ID="ddlGender" runat="server"></asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="lblOrientation" runat="server" Text="Orientation "></asp:Label>
            <asp:DropDownList ID="ddlOrientation" runat="server"></asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="lblEyeColor" runat="server" Text="Eye color "></asp:Label>
            <asp:DropDownList ID="ddlEyeColor" runat="server"></asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="lblHairColor" runat="server" Text="Hair Color "></asp:Label>
            <asp:DropDownList ID="ddlHairColor" runat="server"></asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="lblAgeRange" runat="server" Text="Age Range"></asp:Label>
            <asp:DropDownList ID="ddlAgeRange" runat="server"></asp:DropDownList>
            <br />
            <br />
            <asp:Label ID="lblHobbies" runat="server" Text="Hobbies "></asp:Label>
            <asp:CheckBoxList ID="cblHobbies" runat="server"></asp:CheckBoxList>
            <br />
            <br />
            <br />
            <br />
            <asp:Button ID="btnUpdateDetails" runat="server" Text="Update Personal Details" CssClass="blueButton dashboardButton" OnClick="btnUpdateDetails_Click"/>
            <br />
            <br />
        </div>
</asp:Content>