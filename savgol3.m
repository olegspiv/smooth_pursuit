function y=savgol3(x,look,degree, deriv, rate)

%SAVGOL3  Savitzky-Golay Smoothing Filter
%
%	y=SAVGOL3(x,look,degree, deriv, rate)
%	  SAVGOL3(x,look)        = SAVGOL3(X,look,2,0,1)
%	  SAVGOL3(x)             = SAVGOL3(x,1,2,0,1)
%	etc....
%
%	look    number of points to take from left and right side    10
%	degree  polynom degree of fit polynom                        3
%	deriv   number of derivative;	0 ... smoothing              1
%				1 ... 1st derivative 
%				etc.
%	rate    sampling rate; not important for smoothing only      1000 
%
%  The data at the beginning / end of the sample are deterimined from
%  the best polynomial fit to the first / last datapoints.
%
%
%  "Cutoff-frequencies":
%	for smoothing (deriv=0), the frequency where
%	the amplitude is reduced by 10% is approximately given by
%		f_cutoff = sampling_rate / (1.5 * look)
%
%	for the first derivative (deriv=1), the frequency where
%	the amplitude is reduced by 10% is approximately given by
%		f_cutoff = sampling_rate / (4 * look)
%
%	See also: Siegmund Brandt, Datenanalyse, pp 435
%	          Press et al., Numerical Recipes (2. ed), pp 650
%			Savitzky and Golay: Analytical Chemistry, Vol.36, No.8, Jul64, 1627 ff.
%	
%	Coefficients:
%		C(i,k) = i! / delta_sample * SUM(j=0,..,n) { s_inv[i][j] * k^j }
%		     with i = 0,.., n (= degree of polinomial fitted)
%			  k = -m,..,m (= number of points taken for the fit)
%		     and S[i][j] = SUM(l= -m,..,m) { l^(i+j) },	with i,j = 0,..,n
%
%
%	Thomas, Mar-97
%	Version 2.3
%
% *****************************************************************


% Set the default values if necessary:
if (nargin==1)
	look=1;
	degree=2
	deriv=0;
	rate=1;
elseif (nargin==2)
	degree=2
	deriv=0;
	rate=1;
elseif (nargin==3)
	deriv=0;
	rate=1;
elseif (nargin==4)
	rate=1;
end

% Determine the size of the data:
[n,m]=size(x);

% If necessary, bring them in column form:
if n < m 
	x = x';
	[n,m]=size(x);
end

% Check input arguments:
if (2*look+1>n) 
	disp('Not enough data points!');
	disp('Unless you make "look" smaller, the output is empty.');
	y=[];
	return;
elseif (2*look<degree)
	disp('The "degree" of the polynomial is too high!');
	disp('Unless you make the "degree" smaller, or increase "look", the output is empty.');
	y=[];
	return;
elseif (degree<=deriv)	% The "=" is only to avoid non-sensible output. The
					% code would not crash.
	disp('The "deriv" of the polynomial is too high!');
	disp('Unless you make the "deriv" smaller, or increase "degree", the output is empty.');
	y=[];
	return;
end

% Construct Vandermonde matrix:
a   = zeros(2*look+1,degree+1);
for i=1:2*look+1
  for j=1:degree+1
    a(i,j) = (i-1-look)^(j-1);
  end
end

pa = pinv(a);
p = prod(1:deriv) * rate^deriv * pa(deriv+1,:);  % Savitzky-Golay Coefficients

% Get the coefficients for the fits at the beginning and at the end of the data:
coefs = (0:degree).^sign(deriv);
coef_mat = zeros(degree+1);
row = 1;
for i=deriv+1:degree+1
	coef = coefs(i);
	for j=1:(deriv-1)
		coef = coef * (coefs(i)-j);
	end
	coef_mat(row,row+deriv) = coef;
	row = row + 1;
end;
coef_mat = coef_mat * rate^deriv;
    
% add the first and the last point "look"-times:
x_start = zeros(m, look);
x_end   = zeros(m, look);
for i = 1:look
	x_start(i) = x(1);
	x_end(i) = x(n);
end
x_calc = [x_start x' x_end];

% filter the data:
% for the convolution, the filter coefficients have to be inverted
p = p(length(p):-1:1);
y_filt = [];
for i=1:m
	y_filt = [y_filt; filter(p,1,x_calc(i,:))];	% watch out, the data are transposed!
end

% chop away intermediate data ...
y = y_filt(:, 2*look+1:2*look+n)';

% ...and adjust the first and the last few data:

% filtering for the first few datapoints
y(1:look,:)=a(1:look,:)*coef_mat*pa*x(1:2*look+1,:);

% % smoothing for the inner interval points
% for i=look+1:n-look
%   y(i,:)=p*x(i-look:i+look,:);
% end

% filtering for the last few datapoints
y(n-look+1:n,:)=a(look+2:2*look+1,:)*coef_mat*pa*x(n-2*look:n,:);

