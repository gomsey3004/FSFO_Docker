# FSFO_Docker

Docker files customized to serve as your own Oracle FSFO (Fast Start Failover) for your DR environment. Built on Oracle database client which when deployed will monitor your Primary and Standby database, and will initiate Automatic failover without human interaction. Can be used for both On-Prem and Cloud environments.

For deploying the docker in kubernates use the Deployment_<"DB Version">.yaml file. Make changes to the below env variables.

~~~  
            env:
            - name: PRIMARY_HOST 
              value: "10.1.0.106"
            - name: PRIMARY_DB_PORT 
              value: "1521"
            - name: PRIMARY_DB_SVC 
              value: "DB122_PHX.sub04050841080.gomvcn.oraclevcn.com"
            - name: STANDBY_HOST 
              value: "10.1.0.236"
            - name: STANDBY_DB_PORT 
              value: "1521"
            - name: STANDBY_DB_SVC 
              value: "DB122_phx3dr.sub04050841080.gomvcn.oraclevcn.com"
            - name: SYS_PASSWORD 
              value: "MAnager1234##"
~~~
  
  kubectl apply -f deployments_122.yaml
