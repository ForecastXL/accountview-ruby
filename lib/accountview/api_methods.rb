module Accountview
  class Client
    def companies
      get('/Companies')
    end

    def administrations
      get('/Companies')
    end

    def mutations(book_date)
      params = { params: {
        BusinessObject: 'GJ1',
        PageSize: 400,
        Fields: 'transact.acct_nr,transact.sub_nr,transact.cost_code,transact.proj_code,transact.src_type,transact.src_id,transact.rec_id,transact.trn_date,transact.trn_desc,transact.amount,transact.period',
        BookDate: book_date
        # Fields: '*',
        # filtercontrolsource1: 'transact.trn_date',
        # filteroperator1: 42,
        # filtervaluetype1: 'D',
        # filtervalue1: "{^#{start_date}}",
        # filtercontrolsource2: 'transact.trn_date',
        # filteroperator2: 43,
        # filtervaluetype2: 'D',
        # filtervalue2: "{^#{end_date}}"
        # Filter: "(transact.trn_date >= {^#{start_date}} AND transact.trn_date <= {^#{end_date}})"
      }}

      results = get('/AccountViewData', params)
      check_next(results, 400, '/AccountViewData', params)
    end

    def ledgers(book_date = nil)
      params = { params: {
        BusinessObject: 'GL1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'ledger.acct_nr, ledger.acct_name, ledger.acct_type',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)

      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def periods(book_date = nil)
      params = { params: {
        BusinessObject: 'PER',
        PageSize: DEFAULT_PAGESIZE,
        Fields: '*',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)

      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def creditors(book_date = nil)
      params = { params: {
        BusinessObject: 'ap1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'contact.sub_nr, contact.src_code, contact.acct_name',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def debtors(book_date = nil)
      params = { params: {
        BusinessObject: 'ar1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'contact.sub_nr, contact.src_code, contact.acct_name',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def departments(book_date = nil)
      params = { params: {
        BusinessObject: 'CC1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'cost.cost_code, cost.cost_desc',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def products(book_date = nil)
      params = { params: {
        BusinessObject: 'AK1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'article.art_code, article.art_desc1',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def projects(book_date = nil)
      params = { params: {
        BusinessObject: 'PJ1',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'projects.rec_id, projects.proj_code,projects.sub_nr,projects.proj_desc,project.pro_stat,projects.beg_date,projects.end_date',
        BookDate: book_date

      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def article_history(book_date = nil)
      params = { params: {
        BusinessObject: 'AKH',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'art_line.rec_id, art_line.art_desc1, art_line.proj_code, art_line.art_line_id, art_line.art_code, art_line.art_date',
        BookDate: book_date
      }}

      results = get('/AccountViewData', params)
      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def data_dictionary
      params = { params: {
        BusinessObject: 'dbf',
        PageSize: 1000,
        Fields: 'dct_file.obj_code,dct_file.dbf_des c,dct_file.dbf_name',
        Filter: "!EMPTY(dct_file.obj_code) AND dct_file.dbf_type=2"
      }}

      results = get('/AccountViewData', params)
      #check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def data_dictionary_fields(dbf_name = 'ART_LINE')
      params = { params: {
        BusinessObject: 'FLD',
        PageSize: DEFAULT_PAGESIZE,
        Fields: 'dct_fld.field_name,dct_fld.field_le n,dct_fld.desc_fld,dct_fld.field_type',
        Filter: "dct_fld.dbf_name='#{dbf_name}'"
      }}

      results = get('/AccountViewData', params)

      check_next(results, DEFAULT_PAGESIZE, '/AccountViewData', params)
    end

    def check_next(results, pagesize, path, params)
      key = results.keys.first.to_s

      if results[key].size > 0 && (results[key].size % pagesize) == 0
        pagination_key = 'REC_ID'
        pagination_key = 'SUB_NR' if key == 'CONTACT'
        pagination_key = 'ACCT_NR' if key == 'LEDGER'
        pagination_key = 'DCT_FLD_Id' if key == 'DCT_FLD'
        pagination_key = 'PROJ_CODE' if key == 'PROJECTS'

        params[:params].merge!(lastKey: results[key].last[pagination_key])
        new_results = get(path, params)

        results.deeper_merge!(new_results, {:merge_hash_arrays => false})
        check_next(results, pagesize, path, params)
      else
        results
      end
    end
  end
end
