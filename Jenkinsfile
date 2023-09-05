pipeline{
    environment{
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    agent any
    stages {
        stage('Checkout Source'){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/janit-chawla/notejam.git'
            }
        }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Build Image'){
            steps {
                sh 'docker build -t janit31/my-notejam --no-cache .'
            }
        }
        
        stage('remove kubeconfig if exists') {
           steps {
             sh "rm -rf ${WORKSPACE}/cd_config.yaml"
           }
     }
        stage('setup kubeconfig') {
          steps {
            withCredentials([file(credentialsId: 'cd_config', variable: 'cd_config')]) {
                sh "sudo cp \${cd_config} ${WORKSPACE}/cd_config"
            }
          }
    }
        stage('Pushing Image'){
            steps{
                sh 'docker push janit31/my-notejam'
            }
        }
        stage('Databse'){
            steps{
                sh 'kubectl --kubeconfig ${WORKSPACE}/cd_config config set-context --current --user=cd-sa'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f postgres-secret.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f postgres-deploy.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f postgres-service.yaml'
            }
        }
        stage("Notejam"){
            steps{
                sh 'kubectl --kubeconfig ${WORKSPACE}/cd_config config set-context --current --user=cd-sa'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f persistentvolume.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f persistentvolumeclaim.yaml'
                sh 'kubectl --kubeconfig ${WORKSPACE}/my_config apply -f deployment.yaml'
            }
        }

    }
    post {
    always {
      sh 'docker logout'
    }
  }
}
