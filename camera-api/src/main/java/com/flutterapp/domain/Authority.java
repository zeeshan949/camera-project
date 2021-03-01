package com.flutterapp.domain;


import org.springframework.security.core.GrantedAuthority;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.Size;
import java.io.Serializable;

@Entity
@Table(name = "authority")
public class Authority implements GrantedAuthority, Serializable {

    private static final long serialVersionUID = 1L;

    @Size(max = 50)
    @Id
    @Column(length = 50)
    private String authority;

    @Override
    public String getAuthority() {
        return authority;
    }

    public void setAuthority(String authority) {
        this.authority = authority;
    }
}
