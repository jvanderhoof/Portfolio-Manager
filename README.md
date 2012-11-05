Portfolio-Manager
=================

Portfolio Manager was a side project to try to provide a set of tools to give me a better understanding of how I should be investing.  The app analyzes your retirement saving options, and based on you're household income recommends allocations optimized for taxes.  The app also provides the ability to backtest retirement portfolios based on monthly contributions (ex: $100/month over 10 years - dollar cost average), and email notification of buy lists.

This is a side project I worked on for a couple of months.  The financial/investment space is crowded, but in my humble opinion, filled with overly complex options.  I struggled to find any sort of model other than subscription that might work.  I feel that to be a truly viable product, I would need to integrate into financial accounts like Mint.com does.  Unfortunately is beyond what I have time/resources for at the moment.

Setup
-----
* Checkout the project: git clone https://github.com/jvanderhoof/Portfolio-Manager.git
* Install required gems: bundle install
* Modify the config/database.yml to your development database
* Setup database: rake db:migrate
* Load seed data: rake db:seed - this will load Vanguard and its mutual fund options, and TD Ameritrade free ETF options, as well as historical prices for back testing
* set your SMTP information in the config/environments/development.rb file (and for any other environments you'd like to run the app in)
* set the domain for email - config/environments/development.rb - DOMAIN = 'http://localdomain'
* Start the project using you're favorite server (I like Pow)

Walk-Through
------------
Upon starting the the app and first visiting the site, you'll need to create a new user.  Provide your name, email address, and a password.  Once you've created and account, you'll be directed to the 'Your Information' page.  

You'll be asked to provide the percent of income you'd like to save, as well as you're birthday month (for calculating IRA contribution limits), your annual income, whether you have access to a 401k/403b retirement account, and your marriage status.  If you are married, you'll be able to provide the same information for your spouse.  This is the 'Your Information' tab.

Once you click 'Save', you'll be asked to add the retirement accounts you currently have.  (As this is a prototype, it's a bit rough around the edges.  I've included Vanguard's mutual funds, and TD Ameritrade's fee free ETF funds.  You can add additional companies and available funds by clicking the 'Investment Companies' link in the header).  Select the type of account and the company for each type of retirement account you have for yourself and your partner (if married). This is the 'Accounts' tab.

Once you click 'Save', you'll be asked to setup your desired portfolio.  Select the fund family and desired percentage.  A simple example would be 20% medium term bonds, 60% US Large blend stock, 20% US small blend stock.  You can change this portfolio in the future if you choose. This is the 'Investment Plan' tab.

Once you click 'Save', you'll be shown the suggested allocations for the accounts you provided for the year.  The goal is for a total portfolio, so if one account doesn't have an asset that you need, a higher percentage will be allocated from an another account to make up.  This is the 'Allocations' tab.

Advanced Functionality
-------------------
There is a lot in this project.  Clicking the 'Portfolios' tab allows you to create portfolio based on stock symbols.  I originally built this to allow for backtesting portfolios.  I used this to test different portfolio balance theories (http://www.mymoneyblog.com/model-retirementinvestment-portfolios-a-comparison.html).  It's rough around the edges in that you need to provide symbols rather than just selecting asset categories. This was on my todo list. After creating or changing a portfolio, the dollar cost average is calculated and graphed for as long a period as the portfolio assets have been in existence.

The 'Advanced Investment Plans' tab allows you to select a portfolio and create an investment plan with a start date, initial amount, contribution frequency, and a frequency amount.  If you so choose, you'd receive an email notification with a buy list.  Your buy list is recalculated based on the assets you already own and their value as well as the money you wish to invest for that time period.  I think it would be very interesting automate the purchase and management of the portfolio. 


Tasks That Need to be Run Periodically for advanced functionality
--------------------------------------
* rake tasks:update_asset_prices - needs to be run once a day to set the current market value of each fund/etf/stock
* rake tasks:send_purchase_lists - Generates and sends out an email of the funds you'll need to purchase based on the current market value of what you currently own and your desired portfolio allocation.  This should be run daily, and only sends emails when a purchase needs to be made



TODO
add investment account company link to navigation