using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Npgsql;


namespace PostgreProje
{
    public partial class Form1 : Form
    {
        private String table = "Patient";
        private String table2 = "Selected";
        private String tableuyari = "Table seçiniz!";
        private NpgsqlConnection conn;
        private NpgsqlCommand comm;
        private NpgsqlDataReader datar;
        private DataTable dt;
        public Form1()
        {
            InitializeComponent();
            conn = new NpgsqlConnection("Server=localhost;" +
                                        "Port=5432;" +
                                        "Database=YasliBakimSistemi;" +
                                        "User Id=postgres;" +
                                        "Password=123456455a;");
            conn.Open();
            getTables();
            textBox1.Visible = false;
            textBox2.Visible = false;
            textBox3.Visible = false;
            textBox4.Visible = false;
            textBox5.Visible = false;
            textBox6.Visible = false;
            textBox7.Visible = false;
            label3.Visible = false;
            label4.Visible = false;
            label5.Visible = false;
            label6.Visible = false;
            label7.Visible = false;
            label8.Visible = false;
            label9.Visible = false;
            label10.Visible = false;
            button3.Visible = false;
        }

        private void getTables()
        {
            try
            {
                comm = new NpgsqlCommand();
                comm.Connection = conn;
                comm.CommandType = CommandType.Text;
                comm.CommandText = "SELECT table_name " +
                                   "FROM information_schema.tables " +
                                   "WHERE table_schema='public' AND table_type = 'BASE TABLE'";
                datar = comm.ExecuteReader();
                comboBox1.Items.Clear();
                while (datar.Read())
                {
                    comboBox1.Items.Add((string)datar["table_name"]);
                }
                datar.Close();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }      
        }

        private void showTable()
        {
            try
            {
                comm = new NpgsqlCommand();
                comm.Connection = conn;
                comm.CommandType = CommandType.Text;
                comm.CommandText = "Select * From " + table;
                datar = comm.ExecuteReader();
                if (datar.HasRows)
                {
                    dt = new DataTable();
                    dt.Load(datar);
                    dataGridView1.DataSource = dt;
                }
                datar.Close();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }        
        }

        private void button1_Click_1(object sender, EventArgs e)
        {
            if (comboBox1.SelectedItem != null)
            {
                showTable();
                dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.ColumnHeader;
            }
            else
            {
                MessageBox.Show(tableuyari);
            }

        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            table = comboBox1.SelectedItem.ToString();
        }
        private void Insert_CheckedChanged(object sender, EventArgs e)
        {
            if (Insert.Checked)
            {
                label5.Visible = true;
                label3.Visible = true;
                label6.Visible = true;
                label7.Visible = true;
                label8.Visible = true;
                label9.Visible = true;
                label10.Visible = true;
                label3.Text = " INTO Patient ";
                label4.Text = "Name: ";
                label5.Text = "Surname: ";
                label6.Text = "Birth Date: ";
                label7.Text = "Sex: ";
                label8.Text = "Caretaker ID: ";
                label9.Text = "Relative ID: ";
                label10.Text = "Room No: ";
                textBox1.Visible = true;
                textBox2.Visible = true;
                textBox3.Visible = true;
                textBox4.Visible = true;
                textBox5.Visible = true;
                textBox6.Visible = true;
                textBox7.Visible = true;
                button3.Visible = true;
                label4.Visible = true;
            }
        }

        private void Update_CheckedChanged(object sender, EventArgs e)
        {

            label3.Text = "Caretaker SET";
            if (Update.Checked)
            {
                textBox1.Visible = true;
                label3.Visible = true;
                textBox2.Visible = true;
                textBox3.Visible = false;
                textBox4.Visible = false;
                textBox5.Visible = false;
                textBox6.Visible = false;
                textBox7.Visible = false;
                label4.Text = "Caretaker ID ";
                label5.Text = "Salary";
                label5.Visible = true;
                label6.Visible = false;
                label7.Visible = false;
                label8.Visible = false;
                label9.Visible = false;
                label10.Visible = false;
                button3.Visible = true;
                label4.Visible = true;
            }

        }


        private void Delete_CheckedChanged(object sender, EventArgs e)
        {
            label3.Text = "From";
            if (Delete.Checked)
            {
                textBox1.Visible = true;
                label3.Visible = true;
                textBox2.Visible = false;
                textBox3.Visible = false;
                textBox4.Visible = false;
                textBox5.Visible = false;
                textBox6.Visible = false;
                textBox7.Visible = false;
                label4.Text = "Medicine: ";
                label5.Visible = false;
                label6.Visible = false;
                label7.Visible = false;
                label8.Visible = false;
                label9.Visible = false;
                label10.Visible = false;
                button3.Visible = true;
                label4.Visible = true;
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (Insert.Checked)
            {
                try
                {                     
                    if (textBox6.Text != "")
                    {
                        comm = new NpgsqlCommand("INSERT INTO Patient VALUES(nextval('pseq'), @p1 , @p2 , @p3 , @p4 , @p5 , @p6 , @p7) ", conn);
                        comm.Parameters.AddWithValue("p6", Convert.ToInt32(textBox6.Text));
                    }
                    else
                    {
                        comm = new NpgsqlCommand("INSERT INTO Patient (pid, pname, psurname, birthDate, sex, cid, rno)" +
                            "VALUES(nextval('pseq'), @p1 , @p2 , @p3 , @p4 , @p5 , @p7) ", conn);
                    }
                    comm.Parameters.AddWithValue("p1", textBox1.Text);
                    comm.Parameters.AddWithValue("p2", textBox2.Text);
                    comm.Parameters.AddWithValue("p3", Convert.ToDateTime(textBox3.Text));
                    comm.Parameters.AddWithValue("p4", textBox4.Text);
                    comm.Parameters.AddWithValue("p5", Convert.ToInt32(textBox5.Text));
                    comm.Parameters.AddWithValue("p7", Convert.ToInt32(textBox7.Text));
                    comm.ExecuteNonQuery();
                    textBox1.Text = null;
                    textBox2.Text = null;
                    textBox3.Text = null;
                    textBox4.Text = null;
                    textBox5.Text = null;
                    textBox6.Text = null;
                    textBox7.Text = null;
                    MessageBox.Show("Successfully added.");
                }
                catch (Exception error)
                {
                    MessageBox.Show(error.Message);
                }
                
            }
            else if (Update.Checked)
            {
                try
                {
                    comm = new NpgsqlCommand("UPDATE Caretaker SET salary = @p1" + " WHERE cid = " + Convert.ToInt32(textBox1.Text), conn);

                    comm.Parameters.AddWithValue("p1", Convert.ToInt32(textBox2.Text));

                    comm.ExecuteNonQuery();
                    textBox1.Text = null;
                    textBox2.Text = null;
                    MessageBox.Show("Succesfully updated Caretaker.");
                }
                catch (Exception error)
                {
                    MessageBox.Show(error.Message);
                }
                
            }
            else if (Delete.Checked)
            {    
                try
                {
                    comm = new NpgsqlCommand("DELETE FROM Medicine WHERE mname = @p1 ", conn);

                    comm.Parameters.AddWithValue("p1", textBox1.Text);

                    comm.ExecuteNonQuery();                  
                    textBox1.Text = null;
                    MessageBox.Show("Medicine has been deleted!.");
                }
                catch (Exception error)
                {
                    MessageBox.Show(error.Message);
                }
            }
        }

        private void showTable2()
        {
            try
            {
                String temp = "";
                if (table2 == "Salaries Above Average")
                {
                    temp = "Select * From getSalariesAboveAVG";
                }
                else if (table2 == "Patient with Relative Address")
                {
                    temp = "SELECT pname, psurname FROM Patient WHERE rid IN(SELECT rid FROM Patient WHERE rid IS NOT NULL EXCEPT SELECT rid FROM Relativep WHERE address IS NULL)";
                }
                comm = new NpgsqlCommand();
                comm.Connection = conn;
                comm.CommandType = CommandType.Text;
                comm.CommandText = temp;
                datar = comm.ExecuteReader();
                if (datar.HasRows)
                {
                    dt = new DataTable();
                    dt.Load(datar);
                    dataGridView1.DataSource = dt;
                }
                datar.Close();
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }
            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            try
            {
                if (comboBox2.SelectedItem != null)
                {
                    showTable2();
                    dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.ColumnHeader;
                }
                else
                {
                    MessageBox.Show(tableuyari);
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }        
        }

        private void comboBox2_SelectedIndexChanged(object sender, EventArgs e)
        {
            table2 = comboBox2.SelectedItem.ToString();
        }

        private void button4_Click_1(object sender, EventArgs e)
        {
            try
            {
                if (textBox8.Text != "" && textBox9.Text != "")
                {
                    double temp = Convert.ToDouble(textBox8.Text);
                    temp = 1 + (temp / 100);
                    comm = new NpgsqlCommand();
                    comm.Connection = conn;
                    comm.CommandType = CommandType.Text;
                    comm.CommandText = "UPDATE Caretaker SET salary = salary * @p1 WHERE EXTRACT(YEAR FROM birthdate) < @p2";
                    comm.Parameters.AddWithValue("p1", temp);
                    comm.Parameters.AddWithValue("p2", Convert.ToInt32(textBox9.Text));
                    comm.ExecuteNonQuery();
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }   
        }

        private void button5_Click(object sender, EventArgs e)
        {
            try
            {
                if (textBox10.Text != "")
                {
                    comm = new NpgsqlCommand();
                    comm.Connection = conn;
                    comm.CommandType = CommandType.Text;
                    comm.CommandText = "SELECT getPatientsWithFloor(@p1)";
                    comm.Parameters.AddWithValue("p1", Convert.ToInt32(textBox10.Text));
                    comm.ExecuteNonQuery();
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }        
        }

        private void button6_Click(object sender, EventArgs e)
        {        
            try
            {
                if (textBox11.Text != "" && textBox12.Text != "")
                {
                    comm = new NpgsqlCommand();
                    comm.Connection = conn;
                    comm.CommandType = CommandType.Text;
                    comm.CommandText = "SELECT deleteExpriedMedicines(@p1, @p2)";
                    comm.Parameters.AddWithValue("p1", textBox11.Text);
                    comm.Parameters.AddWithValue("p2", textBox12.Text);
                    comm.ExecuteNonQuery();
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }
        }

        private void button7_Click(object sender, EventArgs e)
        {            
            try
            {
                if (textBox13.Text != "")
                {
                    comm = new NpgsqlCommand();
                    comm.Connection = conn;
                    comm.CommandType = CommandType.Text;
                    comm.CommandText = "SELECT pname, psurname From Patient WHERE cid = @p1";
                    comm.Parameters.AddWithValue("p1", Convert.ToInt32(textBox13.Text));
                    datar = comm.ExecuteReader();
                    if (datar.HasRows)
                    {
                        dt = new DataTable();
                        dt.Load(datar);
                        dataGridView1.DataSource = dt;
                    }
                    datar.Close();
                }
            }
            catch (Exception error)
            {
                MessageBox.Show(error.Message);
            }
        }
    }
}
