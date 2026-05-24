# MLOps System Design Assignment: Demand Forecasting and Recommendations
## Student: Anish Dhondi

---

## Table of Contents
1. [System Design: Business KPIs](#system-design-business-kpis)
2. [MLOps Advantages](#mlops-advantages)
3. [System Architecture](#system-architecture)
4. [Tool Selection Justification](#tool-selection-justification)
5. [Solution Workflow](#solution-workflow)
   - 5.1 [Data and Model Experimentation](#data-and-model-experimentation)
   - 5.2 [Automation of Data Pipeline](#automation-of-data-pipeline)
   - 5.3 [Automation of Training Pipeline](#automation-of-training-pipeline)
   - 5.4 [Automation of Inference Pipeline](#automation-of-inference-pipeline)
   - 5.5 [Continuous Monitoring Pipeline](#continuous-monitoring-pipeline)
6. [Special Scenarios](#special-scenarios)
   - 6.1 [Drift Detection Handling](#drift-detection-handling)
   - 6.2 [New Annotated Data Handling](#new-annotated-data-handling)

---

## 1. System Design: Business KPIs

The e-commerce platform should track the following Key Performance Indicators (KPIs) to measure the success of the ML system:

### 1.1 Recommendation System KPIs

#### Primary Business Metrics:
- **Click-Through Rate (CTR)**: Percentage of users who click on recommended products
  - Target: >5% improvement from current baseline
  - Importance: Measures recommendation relevance and user engagement

- **Conversion Rate**: Percentage of recommendation clicks that result in purchases
  - Target: >3% improvement from current baseline
  - Importance: Directly correlates to revenue generation

- **Revenue Per User (RPU)**: Average revenue generated per user through recommendations
  - Target: 15-20% increase from current baseline
  - Importance: Measures financial impact of personalization

- **Customer Retention Rate**: Percentage of customers who return within 30/90 days
  - Target: 10-15% improvement
  - Importance: Addresses the core business problem of losing customers

#### Engagement Metrics:
- **Session Duration**: Average time users spend on the platform
- **Pages Per Session**: Number of product pages viewed per session
- **Add-to-Cart Rate**: Percentage of recommended products added to cart
- **Cross-sell/Up-sell Rate**: Success rate of recommending complementary products

### 1.2 Demand Forecasting KPIs

#### Accuracy Metrics:
- **Mean Absolute Percentage Error (MAPE)**: Measure forecast accuracy
  - Target: <15% for seasonal products, <10% for regular products
  - Importance: Ensures inventory optimization

- **Stockout Rate**: Percentage of time products are out of stock
  - Target: <5% during normal periods, <10% during peak seasons
  - Importance: Prevents revenue loss and customer dissatisfaction

- **Inventory Turnover**: How quickly inventory is sold and replaced
  - Target: 12-15 times per year for fashion products
  - Importance: Reduces holding costs and obsolescence

#### Operational Metrics:
- **Demand Prediction Lead Time**: Time between prediction and actual demand
- **Forecast Bias**: Tendency to over-forecast or under-forecast
- **Safety Stock Optimization**: Reduction in excess inventory while maintaining service levels

### 1.3 Platform Performance KPIs

#### System Reliability:
- **System Uptime**: Platform availability during peak traffic
  - Target: 99.9% uptime during festivals/seasonal events
  - Importance: Prevents revenue loss during critical periods

- **Response Time**: API response time for recommendations and search
  - Target: <200ms for recommendation API, <500ms for search
  - Importance: Ensures good user experience

- **Scalability Metrics**: System performance under varying loads
  - Peak traffic handling capacity
  - Auto-scaling efficiency

#### Model Performance:
- **Model Freshness**: How recent is the model's training data
- **Model Drift Detection**: Changes in model performance over time
- **A/B Test Success Rate**: Percentage of model updates that show improvement

---

## 2. MLOps Advantages

Building an MLOps system provides significant advantages over deploying simple standalone models:

### 2.1 Scalability and Automation
**Simple Model Approach:**
- Manual model training and deployment
- Limited to batch processing
- Requires manual intervention for updates
- Difficult to scale with business growth

**MLOps System Benefits:**
- **Automated Pipelines**: End-to-end automation from data ingestion to model deployment
- **Real-time Processing**: Can handle both batch and real-time inference
- **Auto-scaling**: Automatically adjusts resources based on demand
- **Continuous Training**: Models automatically retrain with new data

### 2.2 Reproducibility and Version Control
**Simple Model Challenges:**
- Difficulty tracking model versions
- Inconsistent results across environments
- Manual tracking of experiments
- Loss of historical model performance

**MLOps Solutions:**
- **Experiment Tracking**: Complete history of model experiments with MLflow/Weights & Biases
- **Model Versioning**: Systematic versioning with rollback capabilities
- **Environment Consistency**: Containerized deployments ensure consistency
- **Data Lineage**: Track data sources and transformations

### 2.3 Monitoring and Observability
**Simple Model Limitations:**
- No automated performance monitoring
- Manual detection of model degradation
- Reactive approach to issues
- Limited visibility into model behavior

**MLOps Capabilities:**
- **Real-time Monitoring**: Continuous tracking of model performance metrics
- **Drift Detection**: Automated detection of data and model drift
- **Alerting Systems**: Proactive notifications for issues
- **Performance Dashboards**: Visual insights into model behavior

### 2.4 Business Value and Risk Management
**Simple Model Risks:**
- Single point of failure
- Inconsistent model performance
- Delayed response to market changes
- Higher maintenance costs

**MLOps Business Value:**
- **Faster Time-to-Market**: Automated deployment reduces release cycles
- **Improved Model Quality**: Continuous testing and validation
- **Reduced Operational Risk**: Automated rollbacks and failover mechanisms
- **Cost Optimization**: Efficient resource utilization and automated scaling

### 2.5 Collaboration and Governance
**Simple Model Challenges:**
- Siloed development processes
- Lack of collaboration between teams
- No audit trails
- Compliance difficulties

**MLOps Benefits:**
- **Cross-functional Collaboration**: Shared platforms for data scientists, engineers, and business teams
- **Audit Trails**: Complete tracking of model decisions and changes
- **Compliance**: Automated documentation and governance processes
- **Knowledge Sharing**: Centralized experiment and model repositories

---

## 3. System Architecture

### 3.1 High-Level Architecture Overview

The proposed MLOps system follows a microservices architecture with the following key components:

```
┌─────────────────────────────────────────────────────────────────────┐
│                          DATA SOURCES                              │
├─────────────────────────────────────────────────────────────────────┤
│ • User Behavior Data (Clicks, Purchases, Browse History)           │
│ • Product Catalog (Fashion Items, Inventory, Pricing)              │
│ • External Data (Weather, Trends, Seasonal Events)                 │
│ • Historical Sales Data                                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        DATA INGESTION LAYER                        │
├─────────────────────────────────────────────────────────────────────┤
│ • Apache Kafka (Real-time Streaming)                               │
│ • Apache Airflow (Batch Processing Orchestration)                  │
│ • AWS S3/Azure Blob (Data Lake Storage)                            │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      FEATURE STORE & PROCESSING                    │
├─────────────────────────────────────────────────────────────────────┤
│ • Feast Feature Store (Feature Management)                         │
│ • Apache Spark (Large-scale Data Processing)                       │
│ • Redis (Real-time Feature Serving)                                │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┼───────────────┐
                    ▼               ▼               ▼
      ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
      │   EXPERIMENT    │ │    MODEL        │ │    MODEL        │
      │   TRACKING      │ │   TRAINING      │ │   REGISTRY      │
      │                 │ │                 │ │                 │
      │ • MLflow        │ │ • Kubernetes    │ │ • MLflow        │
      │ • Weights&Biases│ │ • Kubeflow      │ │ • DVC           │
      │ • TensorBoard   │ │ • MLflow        │ │ • Model Version │
      └─────────────────┘ └─────────────────┘ └─────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                        MODEL DEPLOYMENT                            │
├─────────────────────────────────────────────────────────────────────┤
│ • Kubernetes (Container Orchestration)                             │
│ • Docker (Containerization)                                        │
│ • NGINX (Load Balancing)                                           │
│ • API Gateway (Request Routing)                                    │
└─────────────────────────────────────────────────────────────────────┘
                    │                               │
                    ▼                               ▼
      ┌─────────────────────────┐     ┌─────────────────────────┐
      │   RECOMMENDATION        │     │   DEMAND FORECASTING   │
      │     MICROSERVICE        │     │     MICROSERVICE       │
      │                         │     │                         │
      │ • Real-time Inference   │     │ • Batch Processing      │
      │ • Collaborative Filter │     │ • Time Series Models   │
      │ • Content-based Filter │     │ • Prophet/ARIMA/LSTM   │
      │ • Deep Learning Models  │     │ • Seasonality Detection│
      └─────────────────────────┘     └─────────────────────────┘
                    │                               │
                    └───────────────┬───────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      MONITORING & OBSERVABILITY                    │
├─────────────────────────────────────────────────────────────────────┤
│ • Prometheus (Metrics Collection)                                  │
│ • Grafana (Visualization & Dashboards)                             │
│ • ELK Stack (Logging: Elasticsearch, Logstash, Kibana)            │
│ • Evidently AI (Model Drift Detection)                             │
│ • Alert Manager (Notifications & Alerting)                         │
└─────────────────────────────────────────────────────────────────────┘
```

### 3.2 Component Details

#### 3.2.1 Data Layer
- **Real-time Data Streaming**: Apache Kafka captures user interactions, clicks, purchases
- **Batch Data Processing**: Historical sales, inventory updates, product catalogs
- **External Data Integration**: Fashion trends, seasonal events, weather data
- **Data Lake Storage**: AWS S3 or Azure Blob for scalable data storage

#### 3.2.2 Feature Engineering Layer
- **Feature Store**: Feast for centralized feature management and sharing
- **Real-time Features**: Redis for low-latency feature serving
- **Batch Features**: Apache Spark for large-scale feature computation
- **Feature Versioning**: Track feature lineage and enable rollbacks

#### 3.2.3 Model Development Layer
- **Experiment Tracking**: MLflow for experiment management and reproducibility
- **Model Training**: Distributed training using Kubernetes and Kubeflow
- **Model Registry**: Centralized model versioning and metadata management
- **CI/CD Integration**: Automated testing and validation pipelines

#### 3.2.4 Deployment Layer
- **Containerization**: Docker for consistent deployment environments
- **Orchestration**: Kubernetes for scalable container management
- **Load Balancing**: NGINX for high availability and traffic distribution
- **API Gateway**: Centralized request routing and authentication

#### 3.2.5 Monitoring Layer
- **Performance Monitoring**: Track model accuracy, latency, and throughput
- **Data Drift Detection**: Monitor changes in input data distributions
- **Model Drift Detection**: Track model performance degradation
- **Business Metrics**: Monitor KPIs and business impact

---

## 4. Tool Selection Justification

### 4.1 Data Infrastructure Tools

#### Apache Kafka (Stream Processing)
**Why Chosen:**
- **Real-time Capability**: Handles millions of user interactions per second
- **Fault Tolerance**: Ensures no data loss during peak traffic
- **Scalability**: Horizontally scalable for growing user base
- **Integration**: Seamless integration with Spark and other tools

**Alternative Considered:** Apache Pulsar
**Decision Rationale:** Kafka's mature ecosystem and extensive community support make it ideal for a production e-commerce platform

#### Apache Airflow (Workflow Orchestration)
**Why Chosen:**
- **Python-native**: Fits well with ML team's skill set
- **DAG Visualization**: Clear view of complex data pipelines
- **Retry Logic**: Built-in error handling and retry mechanisms
- **Extensive Connectors**: Pre-built operators for various data sources

**Alternative Considered:** Prefect, Kubeflow Pipelines
**Decision Rationale:** Airflow's maturity and Python-first approach align with team expertise

### 4.2 ML Platform Tools

#### MLflow (Experiment Tracking & Model Registry)
**Why Chosen:**
- **Open Source**: No vendor lock-in, cost-effective
- **Language Agnostic**: Supports Python, R, Java, Scala
- **Model Packaging**: Standardized model packaging and deployment
- **Integration**: Works well with major cloud providers

**Alternative Considered:** Weights & Biases, Neptune
**Decision Rationale:** MLflow's open-source nature and comprehensive feature set provide flexibility for a growing platform

#### Kubernetes + Docker (Container Orchestration)
**Why Chosen:**
- **Auto-scaling**: Automatic resource scaling based on demand
- **High Availability**: Built-in redundancy and fault tolerance
- **Resource Efficiency**: Optimal resource utilization
- **Cloud Agnostic**: Can run on any cloud provider or on-premises

**Alternative Considered:** AWS ECS, Docker Swarm
**Decision Rationale:** Kubernetes is the industry standard for container orchestration with the largest ecosystem

### 4.3 Feature Store Selection

#### Feast (Feature Store)
**Why Chosen:**
- **Open Source**: Cost-effective and customizable
- **Real-time + Batch**: Supports both serving patterns
- **Point-in-time Correctness**: Ensures feature consistency for training
- **Cloud Integration**: Works with major cloud data stores

**Alternative Considered:** Tecton, AWS SageMaker Feature Store
**Decision Rationale:** Feast provides enterprise-grade capabilities without vendor lock-in

### 4.4 Monitoring Tools

#### Prometheus + Grafana (Metrics & Visualization)
**Why Chosen:**
- **Industry Standard**: Widely adopted monitoring stack
- **Pull-based Model**: Efficient for large-scale deployments
- **Rich Ecosystem**: Extensive community and integrations
- **Alerting**: Built-in alerting with Alert Manager

**Alternative Considered:** DataDog, New Relic
**Decision Rationale:** Open-source solution provides cost savings and flexibility

#### Evidently AI (ML Monitoring)
**Why Chosen:**
- **ML-specific**: Built specifically for ML model monitoring
- **Drift Detection**: Advanced data and model drift detection
- **Easy Integration**: Simple API for custom integrations
- **Open Source**: Cost-effective with commercial support available

**Alternative Considered:** Arize, WhyLabs
**Decision Rationale:** Evidently AI offers the best balance of features, cost, and ease of use for ML monitoring

### 4.5 Hybrid Approach Justification

**Open Source Foundation with Managed Services:**
- **Core Infrastructure**: Use open-source tools (Kafka, Kubernetes, MLflow) for flexibility
- **Managed Storage**: Use cloud-managed databases and storage (AWS RDS, S3) for reliability
- **Monitoring**: Combine open-source monitoring (Prometheus) with managed alerting services
- **Benefits**: Cost optimization, vendor flexibility, while maintaining operational excellence

---

## 5. Solution Workflow

### 5.1 Data and Model Experimentation

#### 5.1.1 Experimentation Environment Setup
**Tools Used:** Jupyter Hub, MLflow, Git, DVC

**Workflow Steps:**

1. **Sandbox Environment Creation**
   ```bash
   # Set up isolated experimentation environment
   kubectl create namespace ml-experiments
   helm install jupyterhub jupyterhub/jupyterhub -n ml-experiments
   ```

2. **Data Access and Exploration**
   - Connect to Feature Store (Feast) for standardized data access
   - Load sample datasets for initial exploration
   - Perform Exploratory Data Analysis (EDA) on user behavior and sales patterns

3. **Experiment Tracking Setup**
   ```python
   import mlflow
   # Configure MLflow tracking server
   mlflow.set_tracking_uri("http://mlflow-server:5000")
   mlflow.set_experiment("recommendation-engine-v1")
   ```

4. **Model Development Process**
   - **Recommendation Models**: Test collaborative filtering, content-based, and hybrid approaches
   - **Demand Forecasting**: Experiment with ARIMA, Prophet, LSTM, and ensemble methods
   - Track all experiments with hyperparameters, metrics, and artifacts

5. **Evaluation Criteria**
   - **Recommendation**: Precision@K, Recall@K, NDCG, diversity metrics
   - **Forecasting**: MAPE, RMSE, MAE for different time horizons

#### 5.1.2 Model Comparison and Selection
- Use MLflow's UI to compare experiments
- Statistical significance testing for model performance
- Business impact simulation for different model approaches

### 5.2 Automation of Data Pipeline

#### 5.2.1 Real-time Data Ingestion
**Tools Used:** Apache Kafka, Kafka Connect, Schema Registry

**Implementation:**
```yaml
# Kafka Topics Configuration
apiVersion: v1
kind: ConfigMap
metadata:
  name: kafka-topics
data:
  user-events: |
    name: user-events
    partitions: 12
    replication-factor: 3
  product-updates: |
    name: product-updates
    partitions: 6
    replication-factor: 3
```

**Data Flows:**
1. **User Interaction Events**: Captures clicks, views, purchases, cart additions
2. **Product Updates**: Real-time inventory changes, price updates
3. **External Events**: Weather data, trending topics, seasonal indicators

#### 5.2.2 Batch Data Processing
**Tools Used:** Apache Airflow, Apache Spark, AWS S3

**DAG Structure:**
```python
from airflow import DAG
from airflow.operators.spark_submit_operator import SparkSubmitOperator
from airflow.providers.aws.operators.s3_file_transform import S3FileTransformOperator

# Daily batch processing DAG
dag = DAG(
    'daily_feature_engineering',
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1)
)

# Data extraction from various sources
extract_sales_data = SparkSubmitOperator(
    task_id='extract_sales_data',
    application='s3://ml-pipeline/jobs/extract_sales.py',
    dag=dag
)

# Feature engineering
engineer_user_features = SparkSubmitOperator(
    task_id='engineer_user_features',
    application='s3://ml-pipeline/jobs/user_features.py',
    dag=dag
)

# Update feature store
update_feature_store = SparkSubmitOperator(
    task_id='update_feature_store',
    application='s3://ml-pipeline/jobs/update_feast.py',
    dag=dag
)

extract_sales_data >> engineer_user_features >> update_feature_store
```

#### 5.2.3 Feature Engineering Pipeline
**Tools Used:** Apache Spark, Feast Feature Store, Redis

**Feature Categories:**
1. **User Features**: Purchase history, browsing patterns, demographics, seasonality preferences
2. **Product Features**: Category, price range, popularity scores, seasonal trends
3. **Contextual Features**: Time of day, day of week, weather, ongoing promotions
4. **Interaction Features**: User-product affinity scores, collaborative filtering signals

**Quality Assurance:**
- Data validation using Great Expectations
- Feature drift monitoring
- Automated data quality alerts

### 5.3 Automation of Training Pipeline

#### 5.3.1 Automated Model Training
**Tools Used:** Kubeflow Pipelines, MLflow, Kubernetes

**Training Pipeline Architecture:**
```python
from kubeflow.pipelines import dsl
from kubeflow.pipelines.components import func_to_container_op

@dsl.pipeline(
    name='ml_training_pipeline',
    description='Automated training for recommendation and forecasting models'
)
def training_pipeline(
    data_path: str = 's3://ml-data/processed',
    model_type: str = 'recommendation',
    experiment_name: str = 'production-training'
):
    # Data validation step
    data_validation = validate_data_op(data_path)
    
    # Feature engineering step
    feature_engineering = feature_engineering_op(data_validation.output)
    
    # Model training step
    model_training = train_model_op(
        feature_engineering.output,
        model_type
    )
    
    # Model validation step
    model_validation = validate_model_op(model_training.output)
    
    # Model registration step
    model_registration = register_model_op(
        model_validation.output,
        experiment_name
    )
```

#### 5.3.2 Hyperparameter Optimization
**Tools Used:** Optuna, Hyperopt integrated with MLflow

**Implementation:**
```python
import optuna
import mlflow.optuna

def objective(trial):
    # Hyperparameter suggestions
    lr = trial.suggest_float('learning_rate', 1e-5, 1e-1, log=True)
    n_factors = trial.suggest_int('n_factors', 50, 200)
    reg_lambda = trial.suggest_float('reg_lambda', 1e-5, 1e-1, log=True)
    
    # Train model with suggested parameters
    model = RecommendationModel(lr=lr, n_factors=n_factors, reg_lambda=reg_lambda)
    model.fit(train_data)
    
    # Evaluate model
    predictions = model.predict(val_data)
    score = calculate_ndcg(val_data, predictions)
    
    return score

# Run optimization
study = optuna.create_study(direction='maximize')
mlflow.optuna.autolog()
study.optimize(objective, n_trials=100)
```

#### 5.3.3 Model Validation and Testing
**Validation Steps:**
1. **Statistical Validation**: Cross-validation, holdout testing
2. **Business Logic Testing**: Ensure recommendations make business sense
3. **A/B Testing Framework**: Shadow testing against current production model
4. **Performance Benchmarking**: Latency and throughput testing

#### 5.3.4 Automated Model Deployment
**Tools Used:** Kubernetes, Docker, MLflow

**Deployment Strategy:**
- **Blue-Green Deployment** for zero-downtime updates
- **Canary Deployment** for gradual rollout
- **Automated rollback** if performance degrades

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: recommendation-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: recommendation-service
  template:
    metadata:
      labels:
        app: recommendation-service
        version: v1.2.0
    spec:
      containers:
      - name: recommendation-api
        image: ml-registry/recommendation:v1.2.0
        ports:
        - containerPort: 8000
        env:
        - name: MODEL_URI
          value: "s3://model-registry/recommendation/v1.2.0"
        resources:
          requests:
            memory: "1Gi"
            cpu: "500m"
          limits:
            memory: "2Gi"
            cpu: "1000m"
```

### 5.4 Automation of Inference Pipeline

#### 5.4.1 Real-time Recommendation Serving
**Tools Used:** FastAPI, Redis, Kubernetes, NGINX

**API Architecture:**
```python
from fastapi import FastAPI
import redis
import mlflow.pyfunc

app = FastAPI()
redis_client = redis.Redis(host='redis-cluster', port=6379, db=0)

# Load model from MLflow
recommendation_model = mlflow.pyfunc.load_model("models:/RecommendationModel/Production")

@app.post("/recommendations/{user_id}")
async def get_recommendations(user_id: str, num_items: int = 10):
    # Get user features from Redis
    user_features = redis_client.hgetall(f"user:{user_id}")
    
    # Get real-time context
    context = get_current_context()
    
    # Generate recommendations
    recommendations = recommendation_model.predict({
        'user_features': user_features,
        'context': context,
        'num_items': num_items
    })
    
    return {
        'user_id': user_id,
        'recommendations': recommendations,
        'timestamp': datetime.now().isoformat()
    }
```

**Performance Optimization:**
- **Caching Strategy**: Redis for user profiles and popular items
- **Load Balancing**: NGINX with round-robin distribution
- **Auto-scaling**: Kubernetes HPA based on CPU/memory usage

#### 5.4.2 Batch Demand Forecasting
**Tools Used:** Apache Airflow, Apache Spark, MLflow

**Forecasting Pipeline:**
```python
@dag(
    dag_id='demand_forecasting_pipeline',
    schedule_interval='0 2 * * *',  # Daily at 2 AM
    start_date=datetime(2024, 1, 1),
    catchup=False
)
def demand_forecasting():
    
    @task
    def extract_sales_data():
        # Extract last 90 days of sales data
        return extract_data_from_warehouse()
    
    @task
    def preprocess_data(raw_data):
        # Clean and prepare data for forecasting
        return preprocess_sales_data(raw_data)
    
    @task
    def generate_forecasts(processed_data):
        # Load forecasting model and generate predictions
        model = mlflow.pyfunc.load_model("models:/DemandForecasting/Production")
        forecasts = model.predict(processed_data)
        return forecasts
    
    @task
    def update_inventory_system(forecasts):
        # Send forecasts to inventory management system
        return update_inventory_recommendations(forecasts)
    
    # Define task dependencies
    raw_data = extract_sales_data()
    processed_data = preprocess_data(raw_data)
    forecasts = generate_forecasts(processed_data)
    update_inventory_system(forecasts)

# Instantiate the DAG
demand_forecasting_dag = demand_forecasting()
```

### 5.5 Continuous Monitoring Pipeline

#### 5.5.1 Model Performance Monitoring
**Tools Used:** Prometheus, Grafana, Evidently AI

**Metrics Collection:**
```python
from prometheus_client import Counter, Histogram, Gauge
import time

# Define metrics
recommendation_requests = Counter('recommendation_requests_total', 'Total recommendation requests')
recommendation_latency = Histogram('recommendation_latency_seconds', 'Recommendation latency')
model_accuracy = Gauge('model_accuracy', 'Current model accuracy')

def monitor_recommendation_endpoint():
    start_time = time.time()
    
    try:
        # Process recommendation request
        result = process_recommendation()
        recommendation_requests.inc()
        
        # Track accuracy if feedback available
        if feedback_available():
            accuracy = calculate_accuracy()
            model_accuracy.set(accuracy)
            
    finally:
        # Record latency
        recommendation_latency.observe(time.time() - start_time)
```

#### 5.5.2 Data Drift Detection
**Implementation:**
```python
from evidently import ColumnMapping
from evidently.report import Report
from evidently.metrics import DataDriftTable, DataDriftMetrics

def detect_data_drift():
    # Load reference and current data
    reference_data = load_reference_data()
    current_data = load_current_data()
    
    # Define column mapping
    column_mapping = ColumnMapping(
        target='purchase',
        prediction='prediction',
        numerical_features=['price', 'user_age', 'session_duration'],
        categorical_features=['category', 'brand', 'season']
    )
    
    # Create drift report
    drift_report = Report(metrics=[DataDriftTable(), DataDriftMetrics()])
    drift_report.run(reference_data=reference_data, 
                    current_data=current_data,
                    column_mapping=column_mapping)
    
    return drift_report
```

#### 5.5.3 Business Metrics Dashboard
**Key Dashboards:**
1. **Real-time Performance**: API latency, throughput, error rates
2. **Model Accuracy**: Precision, recall, NDCG trends over time
3. **Business Impact**: CTR, conversion rate, revenue attribution
4. **System Health**: Resource utilization, auto-scaling events

#### 5.5.4 Alerting Strategy
**Alert Categories:**
1. **Critical**: System down, high error rates (immediate response)
2. **Warning**: Performance degradation, moderate drift (1-hour response)
3. **Info**: Successful deployments, scheduled maintenance (notification only)

```yaml
groups:
- name: ml_system_alerts
  rules:
  - alert: ModelAccuracyDropped
    expr: model_accuracy < 0.7
    for: 15m
    labels:
      severity: warning
    annotations:
      summary: "Model accuracy has dropped below threshold"
      description: "Model accuracy is {{ $value }} which is below 0.7 threshold"
  
  - alert: HighAPILatency
    expr: recommendation_latency_seconds > 0.5
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "High API latency detected"
      description: "API latency is {{ $value }}s which exceeds 0.5s threshold"
```

---

## 6. Special Scenarios

### 6.1 Drift Detection Handling

#### 6.1.1 Drift Detection Components
**Tools Used:** Evidently AI, Prometheus, Custom Python Services

**Automated Drift Detection:**
```python
class DriftDetector:
    def __init__(self, threshold=0.1):
        self.threshold = threshold
        self.reference_data = None
        
    def detect_drift(self, current_data):
        """Detect data drift using statistical tests"""
        
        if self.reference_data is None:
            raise ValueError("Reference data not set")
            
        # Calculate drift score
        drift_score = self.calculate_drift_score(
            self.reference_data, 
            current_data
        )
        
        # Check against threshold
        if drift_score > self.threshold:
            return {
                'drift_detected': True,
                'drift_score': drift_score,
                'severity': self.classify_severity(drift_score),
                'affected_features': self.identify_drifted_features(current_data)
            }
        
        return {'drift_detected': False, 'drift_score': drift_score}
```

#### 6.1.2 Drift Response Pipeline

**When Drift is Detected (Below Threshold):**
1. **Log Warning**: Record drift detection event
2. **Increase Monitoring**: Enhanced data collection and analysis
3. **Feature Analysis**: Identify which specific features are drifting
4. **Stakeholder Notification**: Alert data science team via Slack/email

**When Drift Exceeds Threshold:**
1. **Immediate Actions:**
   ```python
   def handle_critical_drift(drift_info):
       # Stop accepting new prediction requests temporarily
       enable_circuit_breaker()
       
       # Switch to fallback model or rule-based system
       activate_fallback_model()
       
       # Alert on-call engineer
       send_critical_alert(drift_info)
       
       # Trigger automated retraining pipeline
       trigger_retraining_pipeline(drift_info['affected_features'])
   ```

2. **Root Cause Analysis:**
   - Analyze drift patterns and potential causes
   - Check for external factors (seasonal changes, market events)
   - Validate data pipeline integrity

3. **Automated Response Workflow:**
   ```python
   def automated_drift_response():
       # Step 1: Validate current data quality
       if not validate_data_quality():
           fix_data_quality_issues()
           return
       
       # Step 2: Determine if drift is concept drift or data drift
       drift_type = classify_drift_type()
       
       if drift_type == 'data_drift':
           # Update feature preprocessing
           update_feature_preprocessing()
       elif drift_type == 'concept_drift':
           # Retrain model with recent data
           trigger_model_retraining()
       
       # Step 3: Validate fix
       post_fix_validation()
   ```

#### 6.1.3 Fallback Strategies
1. **Model Rollback**: Revert to previous stable model version
2. **Rule-based System**: Use business rules for critical recommendations
3. **Hybrid Approach**: Combine ML predictions with heuristic rules
4. **Graceful Degradation**: Reduce feature complexity temporarily

### 6.2 New Annotated Data Handling

#### 6.2.1 Data Ingestion Pipeline for Annotations
**Trigger Events:**
- User feedback on recommendations (thumbs up/down)
- Purchase confirmations as implicit feedback
- Customer service interactions and reviews
- A/B test results with labeled outcomes

**Automated Pipeline:**
```python
@dag(
    dag_id='annotated_data_processing',
    schedule_interval='@hourly',
    start_date=datetime(2024, 1, 1),
    catchup=False
)
def process_annotated_data():
    
    @task
    def collect_new_annotations():
        """Collect annotations from various sources"""
        # Collect explicit feedback
        explicit_feedback = collect_user_feedback()
        
        # Collect implicit feedback
        implicit_feedback = collect_purchase_data()
        
        # Collect A/B test results
        ab_test_data = collect_ab_test_results()
        
        return merge_annotation_sources(
            explicit_feedback, 
            implicit_feedback, 
            ab_test_data
        )
    
    @task
    def validate_annotations(raw_annotations):
        """Validate and clean annotation data"""
        # Remove duplicates and inconsistencies
        cleaned_data = clean_annotations(raw_annotations)
        
        # Validate annotation quality
        quality_score = assess_annotation_quality(cleaned_data)
        
        if quality_score < QUALITY_THRESHOLD:
            send_quality_alert(quality_score)
            
        return cleaned_data
    
    @task
    def update_training_dataset(validated_annotations):
        """Add new annotations to training dataset"""
        # Load existing training data
        existing_data = load_training_data()
        
        # Merge with new annotations
        updated_data = merge_training_data(existing_data, validated_annotations)
        
        # Save updated dataset
        save_training_data(updated_data)
        
        return updated_data
    
    @task
    def trigger_incremental_training(updated_dataset):
        """Decide whether to trigger model retraining"""
        # Calculate data volume increase
        volume_increase = calculate_volume_increase(updated_dataset)
        
        # Check for performance degradation
        performance_drop = check_current_performance()
        
        # Decide on training strategy
        if volume_increase > VOLUME_THRESHOLD or performance_drop:
            strategy = determine_training_strategy(volume_increase, performance_drop)
            trigger_training_pipeline(strategy)
        
        return strategy
```

#### 6.2.2 Incremental Learning Strategy

**Training Strategy Selection:**
```python
def determine_training_strategy(data_volume, performance_metrics):
    """Determine appropriate training strategy based on conditions"""
    
    if data_volume > FULL_RETRAIN_THRESHOLD:
        return 'full_retrain'
    elif performance_metrics['accuracy_drop'] > CRITICAL_THRESHOLD:
        return 'emergency_retrain'
    elif data_volume > INCREMENTAL_THRESHOLD:
        return 'incremental_update'
    else:
        return 'online_learning'

class IncrementalTrainingPipeline:
    def __init__(self):
        self.current_model = None
        self.training_buffer = []
        
    def process_new_annotations(self, annotations):
        """Process new annotations based on strategy"""
        strategy = determine_training_strategy(
            len(annotations), 
            self.get_current_performance()
        )
        
        if strategy == 'online_learning':
            self.online_update(annotations)
        elif strategy == 'incremental_update':
            self.incremental_retrain(annotations)
        elif strategy in ['full_retrain', 'emergency_retrain']:
            self.schedule_full_retrain(annotations, priority=strategy)
    
    def online_update(self, annotations):
        """Update model with new data without full retraining"""
        # Use techniques like SGD with warm start
        updated_model = self.current_model.partial_fit(annotations)
        
        # Validate updated model
        if self.validate_updated_model(updated_model):
            self.deploy_updated_model(updated_model)
        else:
            self.schedule_full_retrain(annotations)
    
    def incremental_retrain(self, annotations):
        """Retrain with recent data subset"""
        # Combine new annotations with recent training data
        recent_data = self.get_recent_training_data(days=30)
        combined_data = merge_data(recent_data, annotations)
        
        # Retrain model
        retrained_model = self.train_model(combined_data)
        
        # A/B test against current model
        self.schedule_ab_test(retrained_model)
```

#### 6.2.3 Quality Assurance for New Annotations

**Annotation Validation Pipeline:**
```python
class AnnotationQualityValidator:
    def __init__(self):
        self.quality_metrics = {}
        
    def validate_annotations(self, annotations):
        """Comprehensive annotation validation"""
        
        # 1. Consistency checks
        consistency_score = self.check_consistency(annotations)
        
        # 2. Completeness validation
        completeness_score = self.check_completeness(annotations)
        
        # 3. Label quality assessment
        label_quality = self.assess_label_quality(annotations)
        
        # 4. Temporal consistency
        temporal_consistency = self.check_temporal_patterns(annotations)
        
        overall_quality = self.calculate_overall_quality(
            consistency_score,
            completeness_score,
            label_quality,
            temporal_consistency
        )
        
        return {
            'overall_quality': overall_quality,
            'accept': overall_quality > QUALITY_THRESHOLD,
            'recommendations': self.generate_improvement_recommendations(annotations)
        }
```

#### 6.2.4 Automated Retraining Triggers

**Decision Matrix for Retraining:**
```python
RETRAINING_RULES = {
    'immediate': {
        'conditions': [
            'accuracy_drop > 0.1',
            'business_metric_drop > 0.15',
            'critical_failure_detected'
        ],
        'action': 'emergency_retrain'
    },
    'scheduled': {
        'conditions': [
            'new_data_volume > 1000',
            'days_since_last_training > 7',
            'drift_score > 0.05'
        ],
        'action': 'incremental_retrain'
    },
    'experimental': {
        'conditions': [
            'new_feature_available',
            'algorithm_improvement',
            'ab_test_request'
        ],
        'action': 'experimental_training'
    }
}

def evaluate_retraining_need(current_state, new_annotations):
    """Evaluate if retraining is needed based on current conditions"""
    
    for trigger_type, config in RETRAINING_RULES.items():
        if all(evaluate_condition(cond, current_state, new_annotations) 
               for cond in config['conditions']):
            return {
                'retrain_needed': True,
                'strategy': config['action'],
                'priority': trigger_type,
                'estimated_duration': estimate_training_time(config['action'])
            }
    
    return {'retrain_needed': False}
```

This comprehensive MLOps system design addresses all the business requirements while providing a scalable, maintainable, and automated solution for both recommendation systems and demand forecasting challenges.
