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
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://db:5432/demo</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/tmp/iris/postgresql-42.2.14.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="Credentials">PostgreSQL</Setting>
    <Setting Target="Host" Name="batchSize">10</Setting>
  </Item>
  <Item Name="JG" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="INSERT into SQLDB" Category="" ClassName="JDBC.demo.INSERT.operation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="StayConnected">10</Setting>
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://db:5432/demo</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/tmp/iris/postgresql-42.2.14.jar</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="Credentials">PostgreSQL</Setting>
    <Setting Target="Host" Name="batch">10</Setting>
    <Setting Target="Host" Name="batchSize">50000</Setting>
  </Item>
</Production>
}

}
