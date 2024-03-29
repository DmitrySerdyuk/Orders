//Create new order 
function NewOrder(product,quant,orDate,customer,street,city,state,zip,cardType,cardN,cardDate,i)
{
  var mainMenu;
  var groupBox;                            
  mainMenu = Aliases.MainForm.MainMenu;
  groupBox = Aliases.Group;
    //start group log of created order
  Log.AppendFolder("NewOrder# " + (i+1));
  mainMenu.Click("Orders|New order...");
  //Choose product type
  switch(product){
  case 1 : Aliases.Group.ProductNames.ClickItem("MyMoney");break;
  case 2 : Aliases.Group.ProductNames.ClickItem("FamilyAlbum");break;
  case 3 : Aliases.Group.ProductNames.ClickItem("ScreenSaver");break;
  }
  //Enter order data
  groupBox.Quantity.wValue = quant;
  groupBox.Date.wDate = orDate;
  groupBox.Customer.wText = customer;
  groupBox.Street.wText = street;
  groupBox.City.wText = city;
  groupBox.State.wText = state;
  groupBox.Zip.wText = zip;
  //Select creditCard type
  switch(cardType){
  case 1 : Aliases.Group.Visa.Click();break;
  case 2 : Aliases.Group.MasterCard.Click();break;
  case 3 : Aliases.Group.AE.Click();break;
  }
  groupBox.CardNo.wText = cardN;
  groupBox.ExpDate.wDate = cardDate;
  //confirm and create order
  Aliases.ButtonOK.ClickButton();
  //verifying customer field of the order
  Aliases.MainForm.OrdersView.SelectItem(i);
  Delay(100);
  if (Aliases.MainForm.OrdersView.FocusedItem.Text.OleValue == customer)
      Log.Message("Customer verified!");
   else
     Log.Error("Not valid customer name!!");
     //end of grouping log of created order 
     Log.PopLogFolder();       
}

function CustomerEdit(customer,i)
{
  var mainMenu;
  var groupBox;
  //Start of log group
  Log.AppendFolder("EditOrder# " + (i+1));
  mainMenu = Aliases.MainForm.MainMenu;
  //Select an order
  Aliases.MainForm.OrdersView.SelectItem(i);
  //open selected order form
  mainMenu.Click("Orders|Edit order...");
  groupBox = Aliases.Group;
  //Edit Customer Name
  groupBox.Customer.wText = customer;
   Aliases.ButtonOK.ClickButton();
   //verifying customer name
  Aliases.MainForm.OrdersView.SelectItem(i);
  Delay(100); 
  if (Aliases.MainForm.OrdersView.FocusedItem.Text.OleValue == customer)
      Log.Message("Customer verified!");
   else
     Log.Error("Not valid customer name!!");
     //End of log group
     Log.PopLogFolder();          
}

//function to change customer name , and taking customer names from text file
function DataDrivenCustomersEdit()
{
 var driver = DDT.CSVDriver(Files.FileNameByName("CustomerEdit.txt"));
 var i = 0;
 
 while(!driver.EOF())
 {
  CustomerEdit(driver.Value(0),
               i);
  driver.Next();
  i++;
 }
 DDT.CloseDriver("driver");
}



//function to create orders by taking orders ibfo from text file
function DataDrivenNewCustomers()
{
 var driver = DDT.CSVDriver(Files.FileNameByName("NewCustomers.txt"));
 var i = 0;
 
 while(!driver.EOF())
 {
 //call function of order creation and send parameters from text file to the function
  NewOrder(driver.Value(0),
              driver.Value(1),
              driver.Value(2),
              driver.Value(3),
              driver.Value(4),
              driver.Value(5),
              driver.Value(6),
              driver.Value(7),
              driver.Value(8),
              driver.Value(9),
              driver.Value(10),
              i);
  driver.Next();
  i++;
 }
 DDT.CloseDriver("driver");
}

//Delete set number of orders
function OrdersDel(n){
 for (i=0;i<n;i++){
 Log.AppendFolder("DeleteOrder# " + (i+1));
  Aliases.MainForm.OrdersView.SelectItem(0);
  Aliases.MainForm.MainMenu.Click("Orders|Delete order");
  Aliases.Orders.dlgConfirmation.btnYes.ClickButton();
  Log.PopLogFolder(); 
 }
}

function AppRun()
{
  TestedApps.Orders.Run();
}

function AppClose()
{
  Aliases.MainForm.Close();
  Aliases.Orders.dlgConfirmation.btnNo.ClickButton();
}
