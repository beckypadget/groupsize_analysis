data {
  int<lower=1> N;
  array[N] real x;           // time (seconds)
  // real x[N];              // use this one to check if syntax is correct (because it uses rstan which doesn't like arrays)
  vector[N] y;               // response (area of polygon)
  int groupsize_phase[N];              // predictor (before/during predator stimulus)
  int phase[N];
  int group_size[N];         // predictor (group size)
  vector[N] pool_temp;
  vector[N] fish_length;
  int trial_id[N];
  int priors_only;
}

transformed data {
  real delta = 1e-9;         // don't love this fudge factor but it's what stan says to do
}

parameters {
  real<lower=0> rho;         // smoothing term for covariance matrix
  real<lower=0> alpha;       // 
  real<lower=0> kappa;       // 
  vector[N] eta; 
  
  vector[6] b_groupsize_phase;
  vector[2] b_phase;
  vector[3] b_groupsize;
  real b_pooltemp;
  real b_fishlength;
  vector[12] z_trialid;
  real<lower=0> z_sigma;
}

transformed parameters{
  vector[N] f;               // term for gaussian process modelling effect of time
  vector[N] logit_mu;
    {
    matrix[N, N] L_K; // covariance matrix
    matrix[N, N] K = cov_exp_quad(x, alpha, rho);          // kernel function (gets covariance matrix from data)

    // diagonal elements
    for (n in 1:N) {
      K[n, n] = K[n, n] + delta;                           // gets the variance for each data point (adds noise)
    }

    L_K = cholesky_decompose(K);                           // gets the cholesky decomposition of the covariance matrix
    f = L_K * eta;                                         // this describes the effect of time on area
  }
  
  logit_mu = b_groupsize_phase[groupsize_phase] + 
              b_phase[phase] +
              b_groupsize[group_size] + 
              b_pooltemp*pool_temp + 
              b_fishlength*fish_length + 
              z_trialid[trial_id] * z_sigma +
              f;
}

model {
  rho ~ inv_gamma(5, 5);
  alpha ~ std_normal();
  eta ~ std_normal();
  kappa ~ std_normal();
  
  b_groupsize_phase ~ normal(0, 4);
  b_phase ~ normal(0, 4);
  b_groupsize ~ normal(0, 4);
  b_pooltemp ~ normal(0, 4);
  b_fishlength ~ normal(0, 4);
  
  z_trialid ~ normal(0, 4);
  z_sigma ~ normal(0, 2);
  
  if (priors_only == 0){
    y ~ beta_proportion(inv_logit(logit_mu), kappa);
  }
  // y ~ normal(f, sigma);
  
}

generated quantities {
  real y_predicted[N];
  // prior checks
  // real pc_y[N];
  // vector[N] pc_alpha;
  // real pc_beta;
  // vector[N] log_lik;
  
  y_predicted = beta_proportion_rng(inv_logit(logit_mu), kappa);
  // prior checks
  // pc_y = beta_proportion_rng(pc_alpha, pc_beta);
  // pc_alpha = alpha;
  // pc_beta = beta;
  // for (i in 1:N){
  //   log_lik[i] = beta_proportion_lpdf(y[i] | alpha[i], beta);
  // }
}


