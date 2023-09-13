public class HelloSignBulkSignatureRequestWrapper {
    public cls_signature_request signature_request;
    public class cls_signature_request {
        public String signature_request_id;
        public boolean test_mode;
        public String title;
        public String original_title;
        public String subject;
        public Integer created_at;
        public boolean is_complete;
        public boolean is_declined;
        public boolean has_error;
        public String signing_url;
        public String final_copy_uri;
        public String files_url;
        public String details_url;
        public String requester_email_address;
        public cls_signatures[] signatures;
        public cls_response_data[] response_data;
    }
    public class cls_response_data{
        public string api_id;
        public string value;
    }
    class cls_custom_fields {
        public String name;
        public String type;
        public boolean required;
        public String api_id;
    }
    public class cls_signatures {
        public String signature_id;
        public boolean has_pin;
        public boolean has_sms_auth;
        public String signer_email_address;
        public String signer_name;
        public String signer_role;
        public Integer order;
        public String status_code;
    }
}
    /*public cls_bulk_send_job bulk_send_job;
    public cls_list_info list_info;
    public List<cls_signature_requests> signature_requests;

    public class cls_bulk_send_job {
        public String bulk_send_job_id;
        public Integer total;
        public boolean is_creator;
        public Integer created_at;
    }
    public class cls_list_info {
        public Integer page;
        public Integer num_pages;
        public Integer num_results;
        public Integer page_size;
    }
    public class cls_signature_requests {
        public String signature_request_id;
        public boolean test_mode;
        public List<cls_signatures> signatures;
    }
    public class cls_signatures {
        public String signature_id;
        public boolean has_pin;
        public boolean has_sms_auth;
        public String signer_email_address;
        public String signer_name;
        public String signer_role;
        public String status_code;
    }
}*/