package com.xht.myApp.springJdbc;

import com.xht.myApp.springJdbc.domain.Teacher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.PreparedStatementSetter;
import org.springframework.jdbc.core.RowMapper;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by xionghaitao on 16/4/25.
 *
 * reference: http://my.oschina.net/u/437232/blog/279530
 *
 */
public class TeacherService {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // select project_id, sum(budget) as budget from repr_proj_budget_data where project_id in(:ids) group by project_id
    public List<Teacher> findBudgetbyProjectId(List<String> ids)
    {
        if(ids == null  || ids.size() == 0)
        {
            return new ArrayList<Teacher>();
        }
        //String sql = "select project_id, sum(budget) as budget from repr_proj_budget_data where project_id in(?) group by project_id";
        StringBuffer sql = new StringBuffer();
        sql.append("select project_id, sum(budget) as budget from repr_proj_budget_data where project_id in( ");
        appendSqlForIn(ids, sql);
        sql.append(") group by project_id");
        List<Teacher> list = jdbcTemplate.query(sql.toString(), new PreparedStatementSetter(){

            @Override
            public void setValues(PreparedStatement ps) throws SQLException {
                for (int i = 0; i < ids.size(); i++) {
                    ps.setString(i+1, ids.get(i));
                }
            }

        },new RowMapper<Teacher>(){

            @Override
            public Teacher mapRow(ResultSet rs, int rowNum)
                    throws SQLException {
                Teacher pb = new Teacher();
                pb.setId(rs.getString("id"));
                pb.setScore(rs.getFloat("score"));
                return pb;
            }

        });

        return list;
    }

    private void appendSqlForIn(List<String> ids, StringBuffer sql)
    {
        for (int i = 0; i < ids.size(); i++) {
            if(i == ids.size()-1)
            {
                sql.append("? ");
            }
            else
            {
                sql.append("?, ");
            }
        }
    }
}
