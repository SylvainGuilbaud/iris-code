Class JDBC.demo.production Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="JDBC.demo.production" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="SELECT from SQLDB" Category="" ClassName="JDBC.demo.SELECT.operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="StayConnected">10</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://postgres:5432/postgres</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/opt/postgresql-42.2.23.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="Credentials">PostgreSQL</Setting>
    <Setting Target="Host" Name="batchSize">1000</Setting>
  </Item>
  <Item Name="JG" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="INSERT into SQLDB" Category="" ClassName="JDBC.demo.INSERT.operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="StayConnected">10</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://postgres:5432/postgres</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/opt/postgresql-42.2.23.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="Credentials">PostgreSQL</Setting>
    <Setting Target="Host" Name="batchSize">10</Setting>
    <Setting Target="Host" Name="maxToInsert">50</Setting>
  </Item>
  <Item Name="de customers" Category="" ClassName="EnsLib.RecordMap.Service.BatchFileService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BatchClass">data.RM.customer.Batch</Setting>
    <Setting Target="Host" Name="RecordMap">data.RM.customer</Setting>
    <Setting Target="Host" Name="TargetConfigNames">INSERT into SQLDB</Setting>
    <Setting Target="Adapter" Name="FilePath">/tmp/iris/in</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
    <Setting Target="Host" Name="BatchHandling">Whole</Setting>
  </Item>
</Production>
}

}
