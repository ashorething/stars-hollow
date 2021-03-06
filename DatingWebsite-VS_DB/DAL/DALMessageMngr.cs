﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//
using System.Configuration;
using System.Data;
using DataModels;
using System.Data.SqlClient;
using System.Xml;
using ResourceTier;

namespace DAL
{
    public class DALMessageMngr
    {
        private const string CS_NAME = "DatingDB";

        private string conString;

        public DALMessageMngr()
        {
            conString = ConfigurationManager.ConnectionStrings[CS_NAME].ConnectionString;
        }

        public List<Conversation> getSentAndReceivedMessages(int userID)
        {
            return getMessages(userID, Resources.GET_MESSAGES_PROC);
        }

        public List<Conversation> getMessages(int userID, string procname)
        {
            DataSet data = new DataSet();
            List<Conversation> convoList = new List<Conversation>();
            
            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd= new SqlCommand(procname, con))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@userID", SqlDbType.Int).Value = userID;

                    con.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            Conversation convo = new Conversation();

                            convo.ConversationID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(0)).ToString());
                            convo.ParticipantA_ID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(1)).ToString());
                            convo.ParticipantB_ID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(2)).ToString());
                            convo.ParticipantA_Name = reader.GetValue(Convert.ToInt32(3)).ToString();
                            convo.ParticipantB_Name = reader.GetValue(Convert.ToInt32(4)).ToString();

                            // Gets XML data from database and stores it in convo as List<Msssage>.
                            XmlDocument xDoc = new XmlDocument();
                            xDoc.LoadXml(reader.GetValue(Convert.ToInt32(5)).ToString());
                            convo.ConvertXMLToList(xDoc);

                            convoList.Add(convo);
                        }
                    }
                    
                    con.Close();
                }
            }

            return convoList;
        }


        public DataTable getMessagesTest(int userID)
        {
            DataSet data = new DataSet();
            string sql = "Select * from Messages Where SenderID=\'"+userID+"\'";

            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlDataAdapter adapter = new SqlDataAdapter())
                {
                    adapter.SelectCommand = new SqlCommand(sql, con);
                    adapter.SelectCommand.CommandType = CommandType.Text;

                    con.Open();

                    int rowsAffected = adapter.Fill(data);

                    if (rowsAffected < 1)
                    {
                        throw new Exception("Error Retrieving Messages");
                    }

                    con.Close();
                }
            }

            return data.Tables[0];
        }

        public Conversation UpdateConvoTable(Conversation selectedConvo)
        {
           /*
            * This method first updates selectedConvo from the database, 
            * then stores it in the database with the new user-defined messages.
            * */

            Conversation updatedConvo = new Conversation();

            try
            {
                updatedConvo = RefreshConversation(selectedConvo);

                /*
                 * We now have 2 versions of the same conversation: 1 with the user's newest message,
                 * and 1 which might have new messages from the other particpant.
                 * So, add the latest user message to the list of updated messages.
                 * */
                updatedConvo.MessagesList.Add(selectedConvo.MessagesList.ElementAt(selectedConvo.MessagesList.Count - 1));

                using (SqlConnection con = new SqlConnection(conString))
                {
                    using (SqlCommand cmd = new SqlCommand(Resources.UPDATE_CONVO, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@convoID", SqlDbType.Int).Value = updatedConvo.ConversationID;
                        
                        #region Convert List<Message> to XML

                        DataSet ds = new DataSet("Conversation");
                        DataTable dt = new DataTable("Message");
                        dt.Columns.Add("SenderID");
                        dt.Columns.Add("TimeStamp");
                        dt.Columns.Add("Content");

                        ds.Tables.Add(dt);

                        foreach (Message msg in updatedConvo.MessagesList)
                        {
                            DataRow row = dt.NewRow();
                            row["SenderID"] = msg.SenderID;
                            row["TimeSTamp"] = msg.Timestamp;
                            row["Content"] = msg.Content;

                            dt.Rows.Add(row);
                        }
                        ds.AcceptChanges();

                        cmd.Parameters.AddWithValue("@MessageContent", SqlDbType.Xml).Value = ds.GetXml();

                        #endregion

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
            }
            catch (SqlException)
            {
                throw;
            }

            return updatedConvo;
        }

        private Conversation RefreshConversation(Conversation selectedConvo)
        {
            Conversation updatedConvo = new Conversation();
            string procname = Resources.GET_THIS_CONVO;

            try
            {
                using (SqlConnection con = new SqlConnection(conString))
                {
                    using (SqlCommand cmd= new SqlCommand(procname, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@convoID", SqlDbType.Int).Value = selectedConvo.ConversationID;

                        con.Open();

                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                updatedConvo.ConversationID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(0)).ToString());
                                updatedConvo.ParticipantA_ID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(1)).ToString());
                                updatedConvo.ParticipantB_ID = Convert.ToInt32(reader.GetValue(Convert.ToInt32(2)).ToString());
                                updatedConvo.ParticipantA_Name = reader.GetValue(Convert.ToInt32(3)).ToString();
                                updatedConvo.ParticipantB_Name = reader.GetValue(Convert.ToInt32(4)).ToString();

                                // Gets XML data from database and stores it in convo as List<Msssage>.
                                XmlDocument xDoc = new XmlDocument();
                                xDoc.LoadXml(reader.GetValue(Convert.ToInt32(5)).ToString());
                                updatedConvo.ConvertXMLToList(xDoc);

                            }
                        }
                    
                        con.Close();
                    }
                }
            }
            catch (SqlException)
            {
                throw;
            }

            return updatedConvo;
        }

        public bool AddNewConversation(Conversation newConvo)
        {
            bool isAddedSuccessfully = false;

            try
            {
                using (SqlConnection con = new SqlConnection(conString))
                {
                    using (SqlCommand cmd = new SqlCommand(Resources.ADD_NEW_CONVO, con))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@partA_ID", SqlDbType.Int).Value = newConvo.ParticipantA_ID;
                        cmd.Parameters.AddWithValue("@partB_ID", SqlDbType.Int).Value = newConvo.ParticipantB_ID;

                        #region Convert List<Message> to XML

                        DataSet ds = new DataSet("Conversation");
                        DataTable dt = new DataTable("Message");
                        dt.Columns.Add("SenderID");
                        dt.Columns.Add("TimeStamp");
                        dt.Columns.Add("Content");

                        ds.Tables.Add(dt);

                        foreach (Message msg in newConvo.MessagesList)
                        {
                            DataRow row = dt.NewRow();
                            row["SenderID"] = msg.SenderID;
                            row["TimeSTamp"] = msg.Timestamp;
                            row["Content"] = msg.Content;

                            dt.Rows.Add(row);
                        }
                        ds.AcceptChanges();

                        cmd.Parameters.AddWithValue("@MessageContent", SqlDbType.Xml).Value = ds.GetXml();

                        #endregion

                        con.Open();
                        int count = cmd.ExecuteNonQuery();
                        con.Close();

                        if (count > 0)
                        {
                            isAddedSuccessfully = true;
                        }
                    }
                }
            }
            catch (SqlException)
            {
                throw;
            }

            return isAddedSuccessfully;
        }


        // Helper method to add dummy records into the database
        public void InsertIntoConvoTable(Conversation newConvo)
        {
            string query = @"INSERT INTO Conversation
                            (
                                ParticipantA_ID,
                                ParticipantB_ID,
                                MessageContent
                            )
                            VALUES
                            (
                                @partAID,
                                @partBID,
                                @msgContent
                            )";

            using (SqlConnection con = new SqlConnection(conString))
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@partAID", SqlDbType.Int).Value = newConvo.ParticipantA_ID;
                    cmd.Parameters.AddWithValue("@partBID", SqlDbType.Int).Value = newConvo.ParticipantB_ID;

                    #region Convert List<Message> to XML

                    DataSet ds = new DataSet("Conversation");
                    DataTable dt = new DataTable("Message");
                    dt.Columns.Add("SenderID");
                    dt.Columns.Add("TimeStamp");
                    dt.Columns.Add("Content");

                    ds.Tables.Add(dt);

                    foreach (Message msg in newConvo.MessagesList)
	                {
		                DataRow row = dt.NewRow();
                        row["SenderID"] = msg.SenderID;
                        row["TimeSTamp"] = msg.Timestamp;
                        row["Content"] = msg.Content;

                        dt.Rows.Add(row);
	                }
                    ds.AcceptChanges();

                    cmd.Parameters.AddWithValue("msgContent", SqlDbType.Xml).Value = ds.GetXml();

                    #endregion

                    con.Open();

                    int rowsAffected = cmd.ExecuteNonQuery();

                    if (rowsAffected < 1)
                    {
                        throw new Exception("Error Inserting Data");
                    }

                    con.Close();
                }
            }
        }
    }
}
