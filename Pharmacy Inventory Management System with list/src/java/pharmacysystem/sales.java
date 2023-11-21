/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package pharmacysystem;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;

/**
 *
 * @author ccslearner
 */
public class sales {
    public ArrayList<Integer> report_yearList = new ArrayList<>();
    public ArrayList<Integer> report_monthList = new ArrayList<>();
    public ArrayList<Double> total_salesList = new ArrayList<>();
    public ArrayList<Double> total_salaryList = new ArrayList<>();
    public ArrayList<Double> total_costsList = new ArrayList<>();
    public ArrayList<Double> total_profitsList = new ArrayList<>();

    public int getAllSales(){
        report_yearList.clear();
        report_monthList.clear();
        total_salesList.clear();
        total_salaryList.clear();
        total_costsList.clear();
        total_profitsList.clear();
        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            System.out.println("Connection Success.");
            String sqlQuery =   "SELECT\n" +
                                "    report_year,\n" +
                                "    report_month,\n" +
                                "    SUM(total_sales) AS total_sales,\n" +
                                "    SUM(total_salary) AS total_salary,\n" +
                                "    SUM(total_costs) AS total_costs,\n" +
                                "    SUM(total_sales) - SUM(total_salary) - SUM(total_costs) AS total_profits\n" +
                                "FROM (\n" +
                                "    SELECT\n" +
                                "        YEAR(transactionDate) AS report_year,\n" +
                                "        MONTH(transactionDate) AS report_month,\n" +
                                "        SUM(priceBought) AS total_sales,\n" +
                                "        0 AS total_salary,\n" +
                                "        0 AS total_costs\n" +
                                "    FROM\n" +
                                "        transactions\n" +
                                "    GROUP BY\n" +
                                "        report_year, report_month\n" +
                                "\n" +
                                "    UNION\n" +
                                "\n" +
                                "    SELECT\n" +
                                "        YEAR(date_given) AS report_year,\n" +
                                "        MONTH(date_given) AS report_month,\n" +
                                "        0 AS total_sales,\n" +
                                "        SUM(payout_amount) AS total_salary,\n" +
                                "        0 AS total_costs\n" +
                                "    FROM\n" +
                                "        payout\n" +
                                "    GROUP BY\n" +
                                "        report_year, report_month\n" +
                                "\n" +
                                "    UNION\n" +
                                "\n" +
                                "    SELECT\n" +
                                "        YEAR(date_ordered) AS report_year,\n" +
                                "        MONTH(date_ordered) AS report_month,\n" +
                                "        0 AS total_sales,\n" +
                                "        0 AS total_salary,\n" +
                                "        SUM(priceSold * quantity) AS total_costs\n" +
                                "    FROM\n" +
                                "        orders\n" +
                                "    GROUP BY\n" +
                                "        report_year, report_month\n" +
                                ") AS combined_data\n" +
                                "GROUP BY\n" +
                                "    report_year, report_month\n" +
                                "ORDER BY\n" +
                                "    report_year, report_month;";

            PreparedStatement pst = conn.prepareStatement(sqlQuery);
            ResultSet rst = pst.executeQuery();
            while(rst.next()){
                int year_report = rst.getInt("report_year");
                int report_month = rst.getInt("report_month");
                double total_sales = rst.getDouble("total_sales");
                double total_salary = rst.getDouble("total_salary");
                double total_costs = rst.getDouble("total_costs");
                double total_profits = rst.getDouble("total_profits");

                report_yearList.add(year_report);
                report_monthList.add(report_month);
                total_salesList.add(total_sales);
                total_salaryList.add(total_salary);
                total_costsList.add(total_costs);
                total_profitsList.add(total_profits);

            }
            pst.close();
            conn.close();

            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }

    }
    
    public int getAllSalesYearly() {
        report_yearList.clear();
        total_salesList.clear();
        total_salaryList.clear();
        total_costsList.clear();
        total_profitsList.clear();

        try {
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/pharmacy_db?allowPublicKeyRetrieval=true&useTimezone=true&serverTimezone=UTC&user=root&password=12345678&useSSL=false");
            System.out.println("Connection Success.");

            String sqlQuery =   "SELECT\n" +
                                "    report_year,\n" +
                                "    SUM(total_sales) AS total_sales,\n" +
                                "    SUM(total_salary) AS total_salary,\n" +
                                "    SUM(total_costs) AS total_costs,\n" +
                                "    SUM(total_sales) - SUM(total_salary) - SUM(total_costs) AS total_profits\n" +
                                "FROM (\n" +
                                "    -- Get Yearly Sales\n" +
                                "    SELECT\n" +
                                "        YEAR(transactionDate) AS report_year,\n" +
                                "        SUM(priceBought) AS total_sales,\n" +
                                "        0 AS total_salary,\n" +
                                "        0 AS total_costs\n" +
                                "    FROM\n" +
                                "        transactions\n" +
                                "    GROUP BY\n" +
                                "        report_year\n" +
                                "\n" +
                                "    UNION\n" +
                                "\n" +
                                "    -- Get Yearly Salary Report\n" +
                                "    SELECT\n" +
                                "        YEAR(date_given) AS report_year,\n" +
                                "        0 AS total_sales,\n" +
                                "        SUM(payout_amount) AS total_salary,\n" +
                                "        0 AS total_costs\n" +
                                "    FROM\n" +
                                "        payout\n" +
                                "    GROUP BY\n" +
                                "        report_year\n" +
                                "\n" +
                                "    UNION\n" +
                                "\n" +
                                "    -- Get Yearly Drug Cost Report\n" +
                                "    SELECT\n" +
                                "        YEAR(date_ordered) AS report_year,\n" +
                                "        0 AS total_sales,\n" +
                                "        0 AS total_salary,\n" +
                                "        SUM(priceSold * quantity) AS total_costs\n" +
                                "    FROM\n" +
                                "        orders\n" +
                                "    GROUP BY\n" +
                                "        report_year\n" +
                                ") AS combined_data\n" +
                                "GROUP BY\n" +
                                "    report_year\n" +
                                "ORDER BY\n" +
                                "    report_year;";

            PreparedStatement pst = conn.prepareStatement(sqlQuery);
            ResultSet rst = pst.executeQuery();

            while (rst.next()) {
                int year_report = rst.getInt("report_year");
                double total_sales = rst.getDouble("total_sales");
                double total_salary = rst.getDouble("total_salary");
                double total_costs = rst.getDouble("total_costs");
                double total_profits = rst.getDouble("total_profits");

                report_yearList.add(year_report);
                total_salesList.add(total_sales);
                total_salaryList.add(total_salary);
                total_costsList.add(total_costs);
                total_profitsList.add(total_profits);
            }

            pst.close();
            conn.close();

            return 1;
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return 0;
        }
    }

    public sales() {}
}