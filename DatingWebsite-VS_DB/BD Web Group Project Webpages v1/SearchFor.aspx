﻿<%@ Page Title="" Language="C#" MasterPageFile="~/StarsHollow.master" AutoEventWireup="true" CodeBehind="SearchFor.aspx.cs" Inherits="BD_Web_Group_Project_Webpages_v1.SearchFor" %>
<asp:Content ID="Content1" ContentPlaceHolderID="cphStarsHollowHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphStarsHollowBody" runat="server">
    
    <div class="searchForWrapper">
        <h2 id="pageHeader">Search For...</h2>
        <br />
        <section>
            <div class="detailsBox">
                <asp:Label ID="lblTown" runat="server" Text="Town "></asp:Label>
                <asp:TextBox ID="txtTown" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="regxvTown" runat="server" ControlToValidate="txtTown" Display="Dynamic" CssClass="validator" ValidationExpression="[A-Za-z0-9\s\,\.\-]+" ValidationGroup="vgRegisterPage1"><br /> Location may only contain the following characters: <br /> [A-Z] [a-z] [0-9] [space] [,] [.] [-]</asp:RegularExpressionValidator>
                <br />
                <br />
                <asp:Label ID="lblCounty" runat="server" Text="County "></asp:Label>
                <asp:DropDownList ID="ddlCounty" runat="server"></asp:DropDownList>
                <br />
                <br />
                <asp:Label ID="lblProfesssion" runat="server" Text="Profession "></asp:Label>
                <asp:TextBox ID="txtProfession" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="regxvProfession" runat="server" ControlToValidate="txtProfession" Display="Dynamic" CssClass="validator" ValidationExpression="[A-Za-z\s\-]+" ValidationGroup="vgRegisterPage1"><br /> Profession may only contain the following characters: <br /> [A-Z] [a-z] [space] [-]</asp:RegularExpressionValidator>
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
                <asp:Label ID="lblEyeColor" runat="server" Text="Eye Color "></asp:Label>
                <asp:DropDownList ID="ddlEyeColor" runat="server"></asp:DropDownList>
                <br />
                <br />
                <asp:Label ID="lblHairColor" runat="server" Text="Hair Color "></asp:Label>
                <asp:DropDownList ID="ddlHairColor" runat="server"></asp:DropDownList>
                <br />
                <br />
                <asp:Label ID="lblAge" runat="server" Text="Age "></asp:Label>
                <asp:DropDownList ID="ddlAge" runat="server"></asp:DropDownList>
                <br />
                <br />
                <asp:Label ID="lblEthnicity" runat="server" Text="Ethnicity"></asp:Label>
                <asp:DropDownList ID="ddlEthnicity" runat="server"></asp:DropDownList>
                <br />
                <br />
               <asp:Label ID="lblRelationshipStatus" runat="server" Text="Relationship Status"></asp:Label>
               <asp:DropDownList ID="ddlRelationshipStatus" runat="server"></asp:DropDownList>
                <br />
                <br />
                <asp:Label ID="lblHobbies" runat="server" Text="Hobbies "></asp:Label>
                <asp:CheckBoxList ID="cblHobbies" runat="server"></asp:CheckBoxList>
                <br />
                <br />
                <br />
                <br />
                <asp:Button ID="btnSearch" runat="server" Text="Search Now" CssClass="blueButton dashboardButton" OnClick="btnSearch_Click"/>
                <br />
                <br />
            </div>
        </section>
    </div>
</asp:Content>
