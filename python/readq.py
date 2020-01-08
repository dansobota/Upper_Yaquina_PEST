## input data
str_path = 'C:/Users/kbranna/local_repos/pareto'
str_file_in = str_path + '/' + 'UY_do.out'
str_ins_in = str_path + '/' + 'model_ins.txt'
str_model_out = str_path + '/' + 'model.out'

## functions
## function to read the model ins info file
def read_ins_info(str_file_ins):
    dic_ins = {}
    with open(str_file_ins) as f:
        cur = f.readline()
        for line in f:
            cur = str(line).split(',')
            dic_ins[str(cur[1]).strip()] = [str(cur[0]).strip(), str(cur[2]).strip(), str(cur[3]).strip('\n').strip()]
    f.close()
    return dic_ins

## function to read outfile and return dictionary
def read_out(str_file_in):
    dic_local = {}
    ii = 1
    with open(str_file_in) as f:
        for line in f:
            dic_local[ii] = line
            ii = ii + 1
    f.close()
    return dic_local

## function to get integer part of number
def get_int(str_num):
    str_int = str(float(str_num.strip())).split('.')[0]
    return str_int

## function to get indices for specific hour from 0 to 23 
def get_indices(str_hour, str_time):
    indices = [i for i, x in enumerate(str_time) if x == str_hour]
    return indices

## function to get diel time
def get_diel_time(int_ln_st, int_ln_ed, int_col_t_st, int_col_t_ed, dic_out):
    lst_time = []
    for ii in range(int_ln_st, int_ln_ed):
        lst_time.append(get_int(str(dic_out[ii][int_col_t_st:int_col_t_ed]).strip()))
    return lst_time

## function to get diel data
def get_diel_data(int_ln_st, int_ln_ed, int_col_d_st, int_col_d_ed, dic_out):
    lst_data = []
    for ii in range(int_ln_st, int_ln_ed):
        lst_data.append(float(str(dic_out[ii][int_col_d_st:int_col_d_ed]).strip()))
    return lst_data

## function calculate statistic
def calc_stat(str_name, lst_vals):
    if str(str_name).find('ave') > 0:
        stat = sum(lst_vals) / len(lst_vals)
    if str(str_name).find('min') > 0:
        stat = min(lst_vals)
    if str(str_name).find('max') > 0:
        stat = max(lst_vals)
    return stat

## get the instructions
dic_ins = read_ins_info(str_ins_in)

## read QUAL2kw output file
dic_out = read_out(str_file_in)

## loop through instructions and get values
dic_model_out = {}
for jj in list(dic_ins.keys()):
    if dic_ins[jj][0] == 'no':
        ## get individual values
        int_ln = int(dic_ins[jj][1]) # line in file
        int_st = int(str(dic_ins[jj][2]).split('-')[0]) # starting column
        int_ed = int(str(dic_ins[jj][2]).split('-')[1]) # ending column
        dic_model_out[jj] = float(str(dic_out[int_ln])[int_st:int_ed].strip()) # add value to dictionary
        del(int_ln, int_st, int_ed) # clean up
    if dic_ins[jj][0] == 'yes':
        int_col_t_st = 49 # starting column for time
        int_col_t_ed = 73 # ending column for time
        int_ln_st = int(str(dic_ins[jj][1]).split('-')[0]) # starting line
        int_ln_ed = int(str(dic_ins[jj][1]).split('-')[1]) # ending line
        lst_time = get_diel_time(int_ln_st, int_ln_ed,int_col_t_st, int_col_t_ed, dic_out) # get times for data
        lst_indices = get_indices(str(int(jj[-2:])), lst_time)
        int_col_d_st = int(str(dic_ins[jj][2]).split('-')[0]) # starting column for data
        int_col_d_ed = int(str(dic_ins[jj][2]).split('-')[1]) # ending column for data
        lst_data = get_diel_data(int_ln_st, int_ln_ed,int_col_d_st, int_col_d_ed, dic_out) # get data
        dic_model_out[jj] = calc_stat(jj, lst_data[lst_indices[0]:lst_indices[-1]])  # calc stat and add value to dictionary
        del(int_col_t_st, int_col_t_ed, int_ln_st, int_ln_ed, lst_time, lst_indices, int_col_d_st, int_col_d_ed, lst_data) # clean up

## loop through and write output for PEST
with open(str_model_out, 'w') as out_file:
    for kk in list(dic_ins.keys()):
        str_out = str(format(kk, '<20s') + format(dic_model_out[kk], '14.7E') + '\n')
        junk = out_file.write(str_out)
        del(str_out, junk)

