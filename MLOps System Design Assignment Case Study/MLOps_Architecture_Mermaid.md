# MLOps Architecture - Mermaid Diagram Code

## Option 1: Complete System Overview

```mermaid
graph TB
    %% Data Sources Layer
    subgraph DS["🗃️ DATA SOURCES"]
        UB["📱 User Behavior<br/>• Clicks<br/>• Purchases<br/>• Views"]
        PC["🛍️ Product Catalog<br/>• Inventory<br/>• Pricing<br/>• Categories"]
        ED["🌤️ External Data<br/>• Weather<br/>• Trends<br/>• Events"]
        HS["📊 Historical Sales<br/>• Sales History<br/>• Seasonal Data"]
    end

    %% Data Ingestion Layer
    subgraph DI["🔄 DATA INGESTION LAYER"]
        subgraph RT["Real-time Stream"]
            K["Apache Kafka"]
            SR["Schema Registry"]
            KC["Kafka Connect"]
        end
        subgraph BP["Batch Processing"]
            AF["Apache Airflow"]
            S3["AWS S3 Data Lake"]
            ETL["Batch ETL Jobs"]
        end
    end

    %% Feature Store Layer
    subgraph FS["🍽️ FEATURE STORE & PROCESSING"]
        FEAST["Feast Feature Store<br/>• Feature Registry<br/>• Point-in-time<br/>• Versioning"]
        SPARK["⚡ Apache Spark<br/>• ETL Jobs<br/>• Feature Engineering<br/>• Aggregations"]
        REDIS["⚡ Redis Cache<br/>• Low Latency<br/>• User Profiles<br/>• Product Features"]
    end

    %% ML Pipeline Layer
    subgraph ML["🤖 ML PIPELINE"]
        EXP["🧪 EXPERIMENT TRACKING<br/>• MLflow<br/>• Weights&Biases<br/>• TensorBoard<br/>• Hyperopt"]
        TRAIN["🏋️ TRAINING PIPELINE<br/>• Kubernetes<br/>• Kubeflow<br/>• AutoML<br/>• HPO"]
        REG["📚 MODEL REGISTRY<br/>• MLflow<br/>• Model Versions<br/>• A/B Testing<br/>• Rollback"]
    end

    %% Deployment Layer
    subgraph DEP["🚀 MODEL DEPLOYMENT"]
        CONT["🐳 Containerization<br/>• Docker Images<br/>• Model Serving<br/>• Dependencies"]
        ORCH["⚙️ Orchestration<br/>• Kubernetes<br/>• Auto-scaling<br/>• Health Checks"]
        LB["🌐 Load Balancing<br/>• NGINX<br/>• API Gateway<br/>• Rate Limiting"]
    end

    %% Microservices Layer
    subgraph MS["🎯 MICROSERVICES"]
        REC["🎯 RECOMMENDATION<br/>MICROSERVICE<br/>• FastAPI Endpoints<br/>• Real-time Inference<br/>• Collaborative Filter<br/>• Content-based Filter<br/>• Deep Learning Models<br/><br/>Performance:<br/>• <200ms latency<br/>• 1000+ RPS"]
        
        FORE["📈 DEMAND FORECASTING<br/>MICROSERVICE<br/>• Batch Processing<br/>• Time Series Models<br/>• Prophet/LSTM/ARIMA<br/>• Seasonality Detection<br/>• Inventory Optimization<br/><br/>Performance:<br/>• Daily forecasts<br/>• 90 days ahead"]
    end

    %% Monitoring Layer
    subgraph MON["📊 MONITORING & OBSERVABILITY"]
        METRICS["📊 Metrics<br/>• Prometheus<br/>• Custom Metrics<br/>• Model Metrics<br/>• Drift Detection<br/>• Evidently AI"]
        DASH["📈 Dashboards<br/>• Grafana<br/>• Business KPIs<br/>• System Health<br/>• Real-time Monitoring"]
        ALERT["🚨 Alerting<br/>• AlertManager<br/>• PagerDuty<br/>• Slack Alerts<br/>• Escalation Policies"]
        LOGS["🔍 Logs<br/>• ELK Stack<br/>• Fluentd<br/>• Kibana<br/>• Audit Trails"]
    end

    %% Data Flow Connections
    UB --> K
    PC --> AF
    ED --> K
    HS --> AF
    
    K --> FEAST
    AF --> FEAST
    SR --> FEAST
    KC --> FEAST
    S3 --> SPARK
    ETL --> SPARK
    
    FEAST --> EXP
    SPARK --> TRAIN
    REDIS --> REC
    
    EXP --> TRAIN
    TRAIN --> REG
    REG --> CONT
    
    CONT --> ORCH
    ORCH --> LB
    LB --> REC
    LB --> FORE
    
    REC --> METRICS
    FORE --> METRICS
    METRICS --> DASH
    DASH --> ALERT
    ALERT --> LOGS

    %% Feedback Loops
    ALERT -.->|Triggers Retraining| TRAIN
    METRICS -.->|Model Performance| REG
    LOGS -.->|System Health| ORCH

    %% Styling
    classDef dataSource fill:#E3F2FD,stroke:#1976D2,stroke-width:2px
    classDef ingestion fill:#FFF3E0,stroke:#F57C00,stroke-width:2px
    classDef feature fill:#E8F5E8,stroke:#388E3C,stroke-width:2px
    classDef ml fill:#F3E5F5,stroke:#7B1FA2,stroke-width:2px
    classDef deployment fill:#E1F5FE,stroke:#0288D1,stroke-width:2px
    classDef microservice fill:#FFF9C4,stroke:#F9A825,stroke-width:2px
    classDef monitoring fill:#FFEBEE,stroke:#D32F2F,stroke-width:2px

    class UB,PC,ED,HS dataSource
    class K,SR,KC,AF,S3,ETL ingestion
    class FEAST,SPARK,REDIS feature
    class EXP,TRAIN,REG ml
    class CONT,ORCH,LB deployment
    class REC,FORE microservice
    class METRICS,DASH,ALERT,LOGS monitoring
```

## Option 2: Simplified Architecture Flow

```mermaid
flowchart TD
    A[📊 Data Sources] --> B[🔄 Data Ingestion]
    B --> C[🍽️ Feature Store]
    C --> D[🤖 ML Training Pipeline]
    D --> E[📚 Model Registry]
    E --> F[🚀 Model Deployment]
    F --> G[🎯 Recommendation Service]
    F --> H[📈 Forecasting Service]
    G --> I[📊 Monitoring & Alerting]
    H --> I
    I -.->|Feedback| D
    
    style A fill:#E3F2FD
    style B fill:#FFF3E0
    style C fill:#E8F5E8
    style D fill:#F3E5F5
    style E fill:#F3E5F5
    style F fill:#E1F5FE
    style G fill:#FFF9C4
    style H fill:#FFF9C4
    style I fill:#FFEBEE
```

## Option 3: Detailed Component Relationships

```mermaid
graph LR
    subgraph "Data Layer"
        A1[User Events]
        A2[Product Data]
        A3[External Data]
    end
    
    subgraph "Processing Layer"
        B1[Kafka Streams]
        B2[Spark Jobs]
        B3[Feature Store]
    end
    
    subgraph "ML Layer"
        C1[Experiment Tracking]
        C2[Model Training]
        C3[Model Registry]
    end
    
    subgraph "Serving Layer"
        D1[Recommendation API]
        D2[Forecasting API]
    end
    
    subgraph "Monitoring"
        E1[Performance Metrics]
        E2[Business Metrics]
        E3[Drift Detection]
    end
    
    A1 --> B1
    A2 --> B2
    A3 --> B1
    B1 --> B3
    B2 --> B3
    B3 --> C1
    C1 --> C2
    C2 --> C3
    C3 --> D1
    C3 --> D2
    D1 --> E1
    D2 --> E1
    E1 --> E2
    E2 --> E3
    E3 -.->|Retrain| C2
```

## How to Use These Diagrams:

### **Option 1: Online Mermaid Editor**
1. Go to https://mermaid.live/
2. Paste any of the code blocks above
3. The diagram will render automatically
4. Export as PNG/SVG for your Word document

### **Option 2: GitHub/GitLab**
- Paste the code in a README.md file
- The diagram renders automatically in GitHub/GitLab

### **Option 3: VS Code Extension**
1. Install "Mermaid Preview" extension
2. Create a .md file with the mermaid code
3. Preview the diagram directly in VS Code

### **Option 4: Mermaid CLI (if you want local generation)**
```bash
npm install -g @mermaid-js/mermaid-cli
mmdc -i diagram.mmd -o diagram.png
```

### **Recommendation:**
Use **Option 1** (mermaid.live) - it's the quickest way to get a professional diagram for your assignment. Just copy-paste the code and export as high-resolution PNG!

The first diagram (Complete System Overview) is the most comprehensive and perfect for your MLOps assignment submission.